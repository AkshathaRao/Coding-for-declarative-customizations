var bypassValidation = false;  //prevent focus() deadlock on a blank row

// add a new row to the table, and hook up all events.  enabling individual fields handled separately
function insertNewRow(insertAfter, min, max, tlp, util) {
    var newRow = $("<tr class='dataRow'></tr>")
        .append($('<td><input type="button" class="delRow" value="-" title="Remove this Band"/><input type="button" class="addRow" value="+" title="Add a new Band by splitting this row"/></td>'))
        .append($("<td/>").append($("<input class='band bandmin' type='text'/>").val(min)))
        .append($("<td/>").append($("<input class='band bandmax' type='text'/>").val(max)))
        .append($("<td/>").append($("<input class='tlp pct' type='text'/><span>%</span>").val(tlp)))
        .append($("<td/>").append($("<input class='util pct' type='text'/><span>%</span>").val(util)));
    insertAfter.after(newRow);
    $(newRow).find('input').blur(validator);
    $(newRow).find('input.addRow').click(addrow);
    $(newRow).find('input.delRow').click(delrow);
    return newRow;
}

// validation logic.  also, updates prior row minvalue as needed
function validator(evt) {
    if (bypassValidation) return; //prevent focus() deadlock

    clearFeedback();
    var errorMessage = "";
    var val = $(this).val();
    var lastRow = $('.dataRow:last');
    if ($(this).is('.band,.pct')) {
        if (! ($.isNumeric(val) && val > 0)) {
            errorMessage = 'Field must be a positive number';
        }
    };
    if (!errorMessage && $(this).is('.band')) {
        var intRegex = /^\d+$/;
        if(!intRegex.test(val)) {
             errorMessage = 'Band values must be whole numbers';
        }
    }
    if (!errorMessage && $(this).parents('tr:first')[0] == lastRow && $(this).is('.bandmin')) {
        var maxval = $(this).parents('tr:first').find('.bandmax').val();
        if(maxval != "" && parseFloat(val) > parseFloat(maxval)) {
             errorMessage = 'Band minimum must be less than its maximum';
        }
    }
    if (!errorMessage && $(this).is('.bandmax')) {
        var minval = $(this).parents('tr:first').find('.bandmin').val()
        if(minval != "" && parseFloat(val) < parseFloat(minval)) {
             errorMessage = 'Band maximum must be greater than its minimum';
        }
    }
    if (!errorMessage && $(this).is('.pct')) {
        if (parseFloat(val) < 0 || parseFloat(val) > 100) {
            errorMessage = 'Field must be between 0 and 100';
        }
    }
    var priorRow = $(this).parents('tr:first').prev('.dataRow');
    var nextRow  = $(this).parents('tr:first').next('.dataRow');
    if (!errorMessage && priorRow && $(this).is('.bandmin')) {
        if (parseFloat(val) <= parseFloat(priorRow.find('.bandmin').val())) {
            errorMessage = 'Band minimum must be more than than the minimum of the prior band';
        }
    }
    if (!errorMessage && nextRow && $(this).is('.bandmin')) {
        if (parseFloat(val) > parseFloat(nextRow.find('.bandmin').val())) {
            errorMessage = 'Band minimum cannot be more than the minimum of the following band';
        }
    }
    if (errorMessage.length>0) {
        addFeedback(errorMessage, 'error-message');

        var self = this;
        bypassValidation = true; //prevent focus() deadlock
        setTimeout(function() { self.focus(); bypassValidation = false}, 10);
        return;
    }
    else {
        if (priorRow.length && $(this).is('.bandmin')) {
        	var newval = parseInt(val)-1;
            if (parseInt(priorRow.find('.bandmax').val()) != newval) { //only highlight if value changes
            	priorRow.find('.bandmax').val(newval);
            	priorRow.find('.bandmax').effect('highlight', null, 2000);
            };
        }
    }
}

// ensure all fields and buttons are en/dis-abled as appropriate
function updateEnabled() {
    $('input').prop('disabled', false);
    $('.bandmax').prop('disabled',true);
    $('.bandmax:last').prop('disabled', false);
    $('.delRow').prop('disabled', $('.delRow').length==1);

}

function addFeedback(message, messageClass) {
    var msgDiv = $('<div></div>')
        .addClass('feedback')
        .text(message);
    if (typeof messageClass != 'undefined')
    	msgDiv.addClass(messageClass);
    msgDiv.appendTo($('#feedback'));
}

function clearFeedback() {
    $('#feedback').find('div.feedback').remove();
}

// remove an AOVBand row from the table
function delrow() {
    clearFeedback();
    var thisRow = $(this).parents('tr:first');

    var resp = confirm("Are you certain that you wish to remove this Band ?")
    if (resp) {
        var priorRow = thisRow.prev('.dataRow');
        var nextRow  = thisRow.next('.dataRow');
        if (priorRow.length>0 && nextRow.length>0) {
            priorRow.find('.bandmax').val(thisRow.find('.bandmax').val());
        }
        thisRow.remove();
        updateEnabled();
    }
}

// add an band row to the table
function addrow() {
    clearFeedback();
    var thisRow = $(this).parents('tr:first');
    var insertAfter = thisRow;
    var appending = false;
    if ( $(thisRow).is('#rowAddPost') ) {
        insertAfter = insertAfter.prev('tr');
        appending = true
    }
    var newRowMin = appending ? parseInt(insertAfter.find('.bandmax').val()) + 1 : '';
    var nextRow = insertAfter.next('.dataRow')
    var newRowMax = nextRow.length? parseInt(nextRow.find('.bandmin').val()) - 1 : parseInt(insertAfter.find('.bandmax').val());
    newRowMax = newRowMin? '' : newRowMax;
    var newRowTLP = $(thisRow).is('.dataRow') ? $(thisRow).find('.tlp').val(): '';
    var newRowUtil = $(thisRow).is('.dataRow') ? $(thisRow).find('.util').val(): '';

    newRow = insertNewRow(insertAfter, newRowMin, newRowMax, newRowTLP, newRowUtil);
    updateEnabled();

    if (appending) {
        newRow.find('.bandmax').focus();
    }
    else {
        insertAfter.find('.bandmax').val('');
        newRow.find('.bandmin').focus();
    }
}

function encodeRow(row) {
    var r = $(row);
    return {
        'bandmin' : parseInt(r.find('.bandmin').val()),
        'bandmax' : parseInt(r.find('.bandmax').val()),
        'tlp'     : parseFloat(r.find('.tlp').val()),
        'util'    : parseFloat(r.find('.util').val()),
    };
}

function encodeForm() {
    return $('.dataRow').map(function(index, row) { return encodeRow(row); }).get();
}

function saveBands() {
	if (!!$('.error-message').length) { //can't save while errors are active
		return;
	}

	//no blank fields
	var missingInput = $('.dataRow input[type="text"]:enabled').filter(function() {return this.value == null || this.value=='';})
	if (!!missingInput.length) {
		missingInput[0].focus();
		clearFeedback();
		addFeedback('Field cannot be blank', 'error-message');
		return;
	}

	var warningOk = !!$('.warning-message').length; //if click save again while warning on screen, warning is accepted

    clearFeedback();
    $('input').prop('disabled', true);
    addFeedback('Saving...', 'info-message');

    var savebanddata = encodeForm();
    invokeRemoteAction(DFDemo_AdminUIController.saveBands, JSON.stringify(savebanddata), warningOk, function(result) {
        clearFeedback();
        var results = result.split(':');
        var resultMessage = results[1];
        if(results[0] === 'OK') {
        	addFeedback(resultMessage, 'success-message');
        }
        else if(results[0] === 'ERROR') {
        	addFeedback(resultMessage, 'error-message');
        	addFeedback('Please correct before saving.', 'info-message');
        }
        else if (results[0] === 'WARNING') {
        	addFeedback(resultMessage, 'warning-message');
        	addFeedback('Press Save again to proceed.', 'info-message');
        }

        updateEnabled();

        banddata = savebanddata; // banddata used by cancel button.
    }, function(event) {
        clearFeedback();
        addFeedback('UNEXPECTED ERROR: ' + event.message, 'error-message');
        updateEnabled();
    });
}

function loadInitialData() {
    clearFeedback();
    $('.dataRow').remove(); // clear existing data
    var insertAfter = $('#rowAddPre');
    if (bandData.length == 0) {
        //provide a blank row
        bandData = [{"bandmin":"", "bandmax":"", "tlp":"", "util":""}];
    }

    bandData.forEach(function(b) {
        insertAfter = insertNewRow(insertAfter, b.bandmin, b.bandmax, b.tlp, b.util);
    });

    //ensure correct UI state.
    updateEnabled();

}

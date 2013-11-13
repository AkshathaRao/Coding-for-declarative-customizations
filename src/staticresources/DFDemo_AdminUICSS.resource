#bands input[type='text'] {
    width: 75%;
    text-align: right;
}

#bands input.addRow, input.delRow{
    width: 50%;
}

#bands tr td:first-child {
    text-align: right;
    width: 48px;
}

#bands tr, #bands th {
    text-align : center;
}

#feedback, #bands, #pageButtons {
    width: 600px
}

#pageButtons {
    padding-bottom: 15px;
    text-align : center;
}

#rowAddPre td, #rowAddPost td {
    border-width:0 0 1px 0;
}

#bands, #bands tr, #bands th, #bands td {
    border-spacing:0px !important;
}

#bands {
    border: 1px solid #e0e3e5;
}


/* http://css.dzone.com/news/css-message-boxes-different-me */
.info-message, .success-message, .warning-message, .error-message {
    border: 1px solid;
    margin: 10px 0px;
    padding:15px 10px 15px 50px;
    background-repeat: no-repeat;
    background-position: 10px center;
}
.info-message {
    color: #00529B;
    background-color: #BDE5F8;
}
.success-message {
    color: #4F8A10;
    background-color: #DFF2BF;
}
.warning-message {
    color: #9F6000;
    background-color: #FEEFB3;
}
.error-message {
    color: #D8000C;
    background-color: #FFBABA;
}
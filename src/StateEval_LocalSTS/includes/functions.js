/*  shared Common functions */

function GetRadWindow() {
    var oWindow = null;
    if (window.radWindow)
        oWindow = window.radWindow;
    else if (window.frameElement.radWindow)
        oWindow = window.frameElement.radWindow;
    return oWindow;
}

function CloseRadWindow() {
    GetRadWindow().close();
}

function SetFocus(elementID) {
    var element = document.getElementById(elementID);
    if (element != null)
        element.focus();
}

// Removes leading whitespaces
function LTrim(value) {
    var re = /\s*((\S+\s*)*)/;
    return value.replace(re, "$1");
}

// Removes ending whitespaces
function RTrim(value) {
    var re = /((\s*\S+)*)\s*/;
    return value.replace(re, "$1");
}

// Removes leading and ending whitespaces
function trim(value) {
    return LTrim(RTrim(value));
}

// RadPanelBar functions

function stopPanelBarClickPropagation(e) {
    e.cancelBubble = true;

    if (e.stopPropagation)
        e.stopPropagation();
}

function changePanelExpandCollapseImage(eventArgs, imagePath) {
    var panel = eventArgs.get_item();
    var header = panel.get_headerElement();
    var $img = $telerik.$("img", header);
    $img.attr("src", imagePath);
}

function onPanelExpandDefault(sender, eventArgs) {
    changePanelExpandCollapseImage(eventArgs, "images/Arrow_Collapse.png");
}

function onPanelCollapseDefault(sender, eventArgs) {
    changePanelExpandCollapseImage(eventArgs, "images/Arrow_Expand.png");
}

function onPanelExpandFN(sender, eventArgs) {
    changePanelExpandCollapseImage(eventArgs, "images/Arrow_Collapse_FN.png");
}

function onPanelCollapseFN(sender, eventArgs) {
    changePanelExpandCollapseImage(eventArgs, "images/Arrow_Expand_FN.png");
}

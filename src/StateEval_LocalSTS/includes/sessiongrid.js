

function onIsPublicCheckChange(cb, sessionId) {
    $find('RadAjaxManager1').ajaxRequest("CC" + sessionId + "_" + cb.checked);
}

function insertSession(url) {
    var w = radopen(url, "NewObservationRadWindow");
}
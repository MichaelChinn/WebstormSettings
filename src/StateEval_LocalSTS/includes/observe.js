

function togglePullQuotes(cb) {
    var div = cb.parentNode.parentNode.parentNode.children(1);
    if (cb.checked) {
        div.className = "pullquotes hidden";
    }
    else {
        div.className = "pullquotes";
    }
}

function toggleDescriptors(cb) {

    var fn_content = cb.parentNode.parentNode.parentNode;
    var img_tags = fn_content.getElementsByTagName('img');
    var span_tags = fn_content.getElementsByTagName('span');

    for (var i = 0; i < img_tags.length; ++i) {
        if (img_tags(i).className.indexOf("rubric_tt") != -1) {
            if (cb.checked) {
                img_tags(i).className = "rubric_tt";
            }
            else {
                img_tags(i).className = "rubric_tt hidden";
            }
        }
    }

    for (var i = 0; i < span_tags.length; ++i) {
        if (span_tags(i).className.indexOf("rubric_descriptor") != -1) {
            if (cb.checked) {
                span_tags(i).className = "rubric_descriptor hidden";
            }
            else {
                span_tags(i).className = "rubric_descriptor";
            }
        }
    }
}



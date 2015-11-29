  

function isPartOfSchedulerAppointmentArea(htmlElement) {
    // Determines if an html element is part of the scheduler appointment area
    // This can be either the rsContent or the rsAllDay div (in day and week view)
    return $telerik.$(htmlElement).parents().is("div.rsAllDay") ||
                    $telerik.$(htmlElement).parents().is("div.rsContent")
}

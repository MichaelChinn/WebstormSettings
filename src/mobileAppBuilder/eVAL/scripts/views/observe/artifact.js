/**
 * settings view
 */
define([
    'app/api',
    'views/baseview'
], function (api, BaseView) {
    var context = null;

    var View = BaseView.extend({
        view: null,


        init: function () {
            BaseView.fn.init.call(this);
            context = this;
        },

        onInit: function (e) {
        },

        onShow: function (e) {
            context.view = e.view;
            BaseView.fn.setNavBarTitle(this, "Artifact Details");

            $.when(api.getArtifact(parseInt(e.view.params.id)))
                .done(function (artifact) {

                    e.view.element.find(".image").attr("src", App.config.baseUrl + "/api/bitstream/" + artifact.bitstreamId);
                    //e.view.element.find(".video").attr("src", App.config.baseUrl + "/api/bitstream/" + artifact.bitstreamId);
                    // e.view.element.find(".doc").attr("href", App.config.baseUrl + "/api/bitstream/" + artifact.bitstreamId);

                    e.view.element.find('.artifactTitle').text(artifact.itemName);
                    e.view.element.find('.artifactTitle').css('font-weight', 'bold');
                    e.view.element.find('.backbtn').css('display', 'inline-block');
                });
        }
    });

    //RETURN VIEW
    return new View();
});
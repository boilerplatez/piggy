{include file="header.tpl" }

<script src="/src/external/components/blueimp-file-upload/js/jquery.iframe-transport.js"
        type="text/javascript"></script>
<script src="/src/external/components/blueimp-file-upload/js/jquery.fileupload.js" type="text/javascript"></script>
<script src="/src/external/components/cloudinary/js/jquery.cloudinary.js" type="text/javascript"></script>
{cl_js_config}

{if isset($album)}
    <div class="row album_wrapper" id="album_{$album_id}">
        {if $CAN_EDIT_ALBUM }
            <div class="uploadScreenWrapper">
                <label class="uploadScreen container">
                    <span class="glyphicon glyphicon-open-file"></span>
                    <span class="hide">
                        {cl_image_upload_tag}
                    </span>
                </label>
            </div>
        {/if}

        <div class="col-lg-12">
            <h2 class="page-header">{$album.title}
                <small>{$album.description}</small>
            </h2>
        </div>
        <div class="col-lg-6 col-md-6 col-xs-12 thumb big">
            <a class="thumbnail" href="#" target="_blank">
                <img class="img-responsive img-view" src="http://placehold.it/500x500" alt="">
            </a>

            <div class="{if $CAN_LIKE_PIC }btn btn-primary btn-sm{/if} likes_button" type="button">
                <span class="glyphicon glyphicon-ok"></span> Like <span class="badge likes_count">0</span>
            </div>
        </div>
        <div class="col-lg-6 col-md-6 col-xs-12 thumbs_wrapper_outer">
            <div class="thumbs_wrapper">
                {foreach $images as $key=>$image}
                    <div class="col-lg-3 col-md-4 col-xs-3 thumb small">
                        <a class="thumbnail" href="#{$key}_{$image.cloud_name}_{$image.public_name}"
                           data-likes="{$image.likes}" data-id="{$image.id}" data-liked="{$image.liked}">
                            {cl_image_tag public_name=$image.public_name cloud_name=$image.cloud_name class="img-responsive img-thumb" height="64" width="64"
                            alt=$image.original_filename}
                        </a>
                    </div>
                {/foreach}
            </div>
        </div>
    </div>
{/if}

{include file="album_panal.tpl"}
{include file="albums_list.tpl"}

<script>

    {literal}
    $(document).ready(function(e) {
        $("body").on("click", "a.thumbnail", function(e) {

        });

        $(".album_wrapper .thumbs_wrapper").paginate({
            perPage: 12,
            autoScroll: false,
            paginatePosition: ['bottom'],
            useHashLocation: false,
            itemTag: 'li'
        });
        $(".btn.likes_button").click(function() {
            $.post("/api/image_like/" + $(this).attr("image_id")).done(function(resp) {
                console.error("resp", resp);
                $(".thumbs_wrapper .thumb.small a.thumbnail[data-id='" + resp.id + "']").data({
                    liked: resp.liked,
                    likes: resp.likes
                });
                window.onhashchange();
            });
        });
        var hashes = [];
        window.onhashchange = function() {
            var hash = document.location.hash;
            if (!hash) {
                hash = $(".thumbs_wrapper .thumb.small a.thumbnail:eq(0)").attr("href") || "";
                document.location.hash = hash;
            }
            hash = (hash || "").replace("#", "");
            if (hash) {
                hashes = hash.split("_");
                var $img = $.cloudinary.image(hashes[2], {
                    width: 400, height: 400,
                    flags: "progressive",
                    'class': "img-responsive img-view",
                    cloud_name: hashes[1]
                });
                $(".thumb.big .thumbnail").empty().append($img).attr("href", $img[0].src);
                var imageData = $(".thumbs_wrapper .thumb.small a.thumbnail[href='" + document.location.hash + "']").data();
                $(".btn.likes_button").attr("image_id", imageData.id).toggleClass("done", imageData.liked == 1);
                console.error("imageData.liked!=1", imageData.liked)
                $(".likes_count").text(imageData.likes);
            }
        }
        window.onhashchange();
        $(".album_wrapper .thumbs_wrapper").data('paginate').switchPage(Math.floor(hashes[0] / 12) + 1);
    });
    {/literal}

    {if $CAN_EDIT_ALBUM }
    {literal}
    $(document).ready(function() {
        $("body").on("dragover dragenter dragstart drag", ".album_wrapper, .album_wrapper *", function(e) {
            var $elemtn = $(e.target);
            if ($elemtn.hasClass("album_wrapper")) {
                $elemtn.addClass("showDND");
            } else {
                $elemtn.closest(".album_wrapper").addClass("showDND");
            }
        }).on("drop mouseleave", ".album_wrapper", function(e) {
            $(".album_wrapper").removeClass("showDND");
        });

        $('.cloudinary-fileupload').each(function(i, elem) {
            var field = $(this);
            var line = field.closest('.album_wrapper');

            $(elem).cloudinary_fileupload({
                dropZone: line,
                disableImageResize: false,
                imageMaxWidth: 800,                           // 800 is an example value
                imageMaxHeight: 600,                          // 600 is an example value
                maxFileSize: 20000000,                        // 20MB is an example value
                loadImageMaxFileSize: 20000000,               // default is 10MB
                acceptFileTypes: /(\.|\/)(gif|jpe?g|png|bmp|ico)$/i
            }).bind('cloudinarydone', function(e, data) {
                console.error("===cloudinarydone", this, data);
                $.post("/api/image_upload", {
                    imageData: data.result,
                    album_id: line[0].id.split("_")[1]
                }).done(function(resp) {
                    console.error("resp", resp);
                });
                return true;
            }).bind('fileuploadprogress', function(e, data) {
                // console.error("===fileuploadprogress", this, e, data);
            }).bind('fileuploaddrop', function(e, data) {
                //console.error("fileuploaddrop",e,data);
                console.error(e, e.target, elem)
                if (e.target !== elem) {
                    e.preventDefault();
                    return false;
                }
            });
        });
    });
    {/literal}
    {/if}
</script>

{include file="footer.tpl" }
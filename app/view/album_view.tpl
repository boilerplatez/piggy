{include file="header.tpl" }

<script src="/src/external/components/blueimp-file-upload/js/jquery.iframe-transport.js"
        type="text/javascript"></script>
<script src="/src/external/components/blueimp-file-upload/js/jquery.fileupload.js" type="text/javascript"></script>
<script src="/src/external/components/cloudinary/js/jquery.cloudinary.js" type="text/javascript"></script>
{cl_js_config}

{if isset($album)}
    <div class="row album_wrapper" id="album_{$album_id}">

        <div class="col-lg-12">
            <br>
            <span class="album_title"><b>{$album.title}</b>
                <small>{$album.description}</small>
            </span>
            {if $CAN_EDIT_ALBUM }
                <div class="uploadScreenWrapper pull-right">
                    <label class="uploadScreen container">
                        <span class="glyphicon glyphicon-open-file" style="font-size: 26px;"></span>
                    <span class="hide">
                        {cl_image_upload_tag}
                    </span>
                    </label>
                </div>
            {/if}
            <hr/>
        </div>
        <div class="col-lg-6 col-md-6 col-xs-12 thumb big">
            <div style="height: 100%; position: relative">
                <a class="show-prev" href="#"><span class="glyphicon glyphicon-chevron-left"></span></a>
                <a class="show-next" href="#"><span class="glyphicon glyphicon-chevron-right"></span></a>
                <a class="thumbnail" href="#" target="_blank">
                    <img class="img-responsive img-view" src="http://placehold.it/500x500" alt="">
                </a>
            </div>
            <div class="{if $CAN_LIKE_PIC }btn btn-primary{/if} btn-xs likes_button" type="button">
                <span class="glyphicon glyphicon-ok"></span> Like <span class="badge likes_count">0</span>
            </div>
            <div class="clearfix"></div>
            <br/>
        </div>
        <div class="col-lg-6 col-md-6 col-xs-12 thumbs_wrapper_outer">
            <div class="thumbs_wrapper">
                {foreach $images as $key=>$image}
                    <div class="col-lg-2 col-md-3 col-sm-2 col-xs-3 thumb small">
                        <a class="thumbnail" href="#{$image.cloud_name}_{$image.public_name}"
                           data-likes="{$image.likes}" data-id="{$image.id}" data-liked="{$image.liked}" data-inorder="{$key}">
                            {cl_image_tag public_name=$image.public_name cloud_name=$image.cloud_name class="img-responsive img-thumb" height="50" width="50"
                            alt=$image.original_filename}
                        </a>
                    </div>
                {/foreach}
            </div>
        </div>
        <div id="disqus_thread"></div>
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
            perPage: 18,
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
        var cur_page = 0;
        window.onhashchange = function() {
            var hash = document.location.hash;
            if (!hash) {
                hash = $(".thumbs_wrapper .thumb.small a.thumbnail:eq(0)").attr("href") || "";
                document.location.hash = hash;
            }
            hash = (hash || "").replace("#", "");
            if (hash) {
                hashes = hash.split("_");
                var $img = $.cloudinary.image(hashes[1], {
                    width: 400, height: 400,
                    flags: "progressive",
                    'class': "img-responsive img-view",
                    cloud_name: hashes[0]
                });
                $(".thumb.big .thumbnail").empty().append($img).attr("href", $img[0].src);
                $curSor =  $(".thumbs_wrapper .thumb.small a.thumbnail[href='" + document.location.hash + "']");
                $curParent = $curSor.closest(".thumb.small");
                $(".show-prev").attr("href",$curParent.prev().find("a.thumbnail").attr("href"));
                $(".show-next").attr("href",$curParent.next().find("a.thumbnail").attr("href"));
                var imageData =$curSor.data();
                if(imageData){
                    cur_page = imageData.inorder;
                    $(".btn.likes_button").attr("image_id", imageData.id).toggleClass("done", imageData.liked == 1);
                    $(".likes_count").text(imageData.likes);
                }
            }
        }
        window.onhashchange();
        (function($dom){
            if($dom){
                $dom.switchPage(Math.floor(cur_page / 18) + 1);
            }
        })($(".album_wrapper .thumbs_wrapper").data('paginate'))

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
<script>
    var disqus_config = function() {literal}{{/literal}
        this.page.remote_auth_s3 = "{$disqus_config.message} {$disqus_config.hmac} {$disqus_config.timestamp}";
        this.page.api_key = "{$disqus_config.DISQUS_PUBLIC_KEY}";
        this.page.url = 'http://piggy.localhost.com/u/{$penname}/album/{$album_id}';  // Replace PAGE_URL with your page's canonical URL variable
        this.page.identifier = '{$album_id}'; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
        {literal} }{/literal}
    {literal}
</script>

<script>
    /**
     *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
     *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables
     */
    /*
     var disqus_config = function () {
     this.page.url = PAGE_URL;  // Replace PAGE_URL with your page's canonical URL variable
     this.page.identifier = PAGE_IDENTIFIER; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
     };
     */
    (function() {  // REQUIRED CONFIGURATION VARIABLE: EDIT THE SHORTNAME BELOW
        var d = document, s = d.createElement('script');

        s.src = '//piggy-1.disqus.com/embed.js';  // IMPORTANT: Replace EXAMPLE with your forum shortname!

        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
    })();
    {/literal}
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>

{include file="footer.tpl" }
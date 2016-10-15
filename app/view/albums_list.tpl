<div class="row list-group">
    {foreach from=$albums item=album}
        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 album_thumb">
            <li class="media list-group-item">
                <a href="/u/{$penname}/album/{$album.id}">
                    <div class="media-left">
                        {cl_image_tag public_name=$album.public_name cloud_name=$album.cloud_name class="media-object" height="64" width="64"}
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading">{$album.title}</h4>
                        <small>{$album.description}</small>
                    </div>
                </a>
            </li>
        </div>
    {/foreach}
</div>

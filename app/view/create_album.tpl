{include file="header.tpl" }
<div class="row album_wrapper" id="album_new">
    <div class="col-lg-12">
        <h2 class="page-header">Add Album
            <small>Fill Details</small>
        </h2>
    </div>

    <form class="form-horizontal" action="/create_album" method="post">
        <div class="form-group">
            <label class="control-label col-sm-2" for="email">Title:</label>

            <div class="col-sm-10">
                <input type="text" class="form-control" id="email" placeholder="Enter title" required name="title"
                        value="{$title}">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="pwd">Description:</label>

            <div class="col-sm-10">
                <input type="text" class="form-control" id="pwd" placeholder="Enter description" required name="description"
                       value="{$description}">
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <div class="checkbox">
                    <label><input type="checkbox" {if $private}checked{/if}> Private</label>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" class="btn btn-default">Create</button>
            </div>
        </div>
    </form>


</div>
{include file="footer.tpl" }
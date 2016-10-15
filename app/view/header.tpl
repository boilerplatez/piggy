<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Piggy</title>

    <link href="/src/external/components/webmodules-bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="/src/style/main.css" rel="stylesheet">
    <link href="/src/pager/src/jquery.paginate.css" rel="stylesheet">

    <script src="/src/external/components/jquery/dist/jquery.js" type="text/javascript"></script>
    <script src="/src/external/components/jquery.ui/ui/widget.js" type="text/javascript"></script>
    <script src="/src/pager/src/jquery.paginate.js"></script>

</head>

<body>
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/albums">Piggy</a>
            <form class="navbar-form pull-right" role="search" method="get" id="searchform" action="/search/penname">
                <div class="input-group">
                    <input type="text" class="form-control" value="" placeholder="Search..." name="s" id="s">
                    <div class="input-group-btn">
                        <button type="submit" id="searchsubmit" value="Search" class="btn btn-success"><span class="glyphicon glyphicon-search"></span></button>
                    </div>
                </div>
            </form>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li>
                    <a href="/albums">Albums</a>
                </li>
            </ul>
        </div>
        <div class="navbar-header">
            </div>
    </div>
</nav>

<div class="container">

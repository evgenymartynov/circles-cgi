<html>
<head>
    <title>Circles</title>
    <link rel="stylesheet" type="text/css" href="/static/style.css">
    <%block name="head">
    </%block>
</head>
<body>
    <header>
        <div class="column">
            <h1>Circles</h1>
            <h3>Automatic UNSW timetabler for semester two</h3>
        </div>
    </header>

    <div class="main-container">
        <div id="body-gradient"></div>
        <div id="content" class="column">
            <%block name="content">
            </%block>
        </div>
    </div>
</body>
</html>

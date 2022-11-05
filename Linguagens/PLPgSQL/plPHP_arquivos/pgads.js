/* Called by ad code to set the contents of the ad wrapper */
function pgSetAdHtml(html)
{
    try 
    {
        var x = document.getElementById('pgSponsorContents');
        if (x)
        {
            x.innerHTML = html;
        }
    }
    catch (e)
    {
        /* Ignore any errors so we don't create a popup */
    }
}

/* Try to load the ads code async, so we don't hang if the ads server is down */
function pgAdsLoad()
{
    try
    {
        var x = document.getElementById('pgSponsorContents');
        if (x)
        {
            var scr = document.createElement('script');
            scr.src = 'http://200.46.208.156/adjs2.php';
            scr.type = 'text/javascript';
            document.getElementsByTagName('head')[0].appendChild(scr);
        }
    }
    catch (e)
    {
        /* Ignore any errors, so we don't popup anything */
    }
}


// https://github.com/pyllyukko/user.js/

user_pref("browser.aboutConfig.showWarning", 0)

user_pref("browser.download.folderList", 2) // https://old.reddit.com/r/firefox/comments/119u60b/firefox_doesnt_ask_me_for_download_folder/j9oceyh/

user_pref("browser.download.open_pdf_attachments_inline", 0) // https://superuser.com/a/1837432

// user_pref("browser.download.start_downloads_in_tmp_dir", 1) // https://superuser.com/questions/1712074/revert-behaviour-of-new-firefox-98-regarding-downloaded-files

user_pref("browser.download.useDownloadDir", 0) // https://old.reddit.com/r/firefox/comments/119u60b/firefox_doesnt_ask_me_for_download_folder/j9oceyh/

user_pref('browser.low_commit_space_threshold_mb', 32000) // https://dev.to/msugakov/taking-firefox-memory-usage-under-control-on-linux-4b02

// user_pref('browser.low_commit_space_threshold_percent', 50) // https://dev.to/msugakov/taking-firefox-memory-usage-under-control-on-linux-4b02

user_pref('browser.tabs.loadInBackground', 1) // https://superuser.com/questions/741649/how-to-prevent-background-tabs-from-loading-in-firefox

user_pref('browser.tabs.min_inactive_duration_before_unload', 60000) // https://unix.stackexchange.com/questions/708768/firefox-offloads-tab-after-a-short-time-how-to-adjust-the-time

user_pref('browser.tabs.unloadOnLowMemory', 1) // https://firefox-source-docs.mozilla.org/browser/tabunloader/

user_pref('browser.sessionstore.restore_on_demand', 1) // https://superuser.com/questions/1086541/how-do-i-make-firefox-47-load-all-my-tabs-on-startup

user_pref('browser.sessionstore.restore_tabs_lazily', 1) // https://superuser.com/questions/1086541/how-do-i-make-firefox-47-load-all-my-tabs-on-startup

user_pref("browser.startup.page", 3); // http://kb.mozillazine.org/Browser.startup.page

// user_pref('browser.urlbar.oneOffSearches', 0) // https://www.askvg.com/firefox-tip-remove-this-time-search-with-one-click-search-buttons-from-address-bar/

// user_pref('browser.urlbar.showSearchSuggestionsFirst', 0) // https://support.mozilla.org/gl/questions/1445570

user_pref('browser.urlbar.suggest.searches', 0) // https://www.askvg.com/disable-all-kind-of-suggestions-in-mozilla-firefox-address-bar/

user_pref('findbar.highlightAll', 1) // https://www.addictivetips.com/web/highlight-all-matches-firefox-find-bar/

user_pref("network.proxy.type", 2); // http://kb.mozillazine.org/Network.proxy.type

user_pref("network.proxy.autoconfig_url", "https://delannoy.web.cern.ch/proxy.pac"); // http://kb.mozillazine.org/Network.proxy.autoconfig_url

user_pref("pdfjs.defaultZoomValue", "page-width"); // https://newscrewdriver.com/2023/10/02/make-firefox-pdf-viewer-default-to-page-fit-zoom/ https://superuser.com/a/888856

user_pref('pdfjs.enableHighlightFloatingButton', 0)

user_pref("signon.rememberSignons", 0)

user_pref("startup-restore-windows-and-tabs", 1)

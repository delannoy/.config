
// https://kb.mozillazine.org/User.js_file
// https://searchfox.org/mozilla-central/source/modules/libpref/init/StaticPrefList.yaml
// https://kb.mozillazine.org/About:config_entries

user_pref("browser.aboutConfig.showWarning", false);

// [same as Settings > General > Files and Applications > What should Firefox do with other files? > Ask whether to open or save files](https://wiki.archlinux.org/title/Firefox#Additional_settings_to_consider)
user_pref("browser.download.always_ask_before_handling_new_types", true);

// https://old.reddit.com/r/firefox/comments/119u60b/firefox_doesnt_ask_me_for_download_folder/j9oceyh/
user_pref("browser.download.folderList", 2); // [2: the last folder specified for a download]

// [How to view pdf online without downloading](https://superuser.com/a/1837432)
// [PDFs are opening in browser AND downloading](https://support.mozilla.org/en-US/questions/1387228)
user_pref("browser.download.open_pdf_attachments_inline", true);

// https://superuser.com/questions/1712074/revert-behaviour-of-new-firefox-98-regarding-downloaded-files
// https://wiki.archlinux.org/title/Firefox#My_downloads_directory_is_full_of_files_I_do_not_remember_saving
user_pref("browser.download.start_downloads_in_tmp_dir", true);

// https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#downloads
user_pref("browser.download.useDownloadDir", false); // [False: Ask where to save every file]

// https://dev.to/msugakov/taking-firefox-memory-usage-under-control-on-linux-4b02
user_pref('browser.low_commit_space_threshold_mb', 60000);
user_pref('browser.low_commit_space_threshold_percent', 95);

// https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#new-tab-shortcuts
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showWeather", false);

// [True (default): Do not focus new tabs opened from links (load in background)]
// https://superuser.com/questions/741649/how-to-prevent-background-tabs-from-loading-in-firefox
user_pref('browser.tabs.loadInBackground', true);

// https://unix.stackexchange.com/questions/708768/firefox-offloads-tab-after-a-short-time-how-to-adjust-the-time
user_pref('browser.tabs.min_inactive_duration_before_unload', 3600000);

// https://firefox-source-docs.mozilla.org/browser/tabunloader/
user_pref('browser.tabs.unloadOnLowMemory', true);

// https://superuser.com/questions/1086541/how-do-i-make-firefox-47-load-all-my-tabs-on-startup
user_pref('browser.sessionstore.restore_on_demand', true);
user_pref('browser.sessionstore.restore_tabs_lazily', true);

// http://kb.mozillazine.org/Browser.startup.page
user_pref("browser.startup.page", 3); // [3: Resume the previous browser session]

// https://support.mozilla.org/gl/questions/1445570
user_pref('browser.urlbar.showSearchSuggestionsFirst', false);

// https://www.askvg.com/disable-all-kind-of-suggestions-in-mozilla-firefox-address-bar/
user_pref('browser.urlbar.suggest.engines', false);
user_pref('browser.urlbar.suggest.searches', false);

// https://www.addictivetips.com/web/highlight-all-matches-firefox-find-bar/
user_pref('findbar.highlightAll', true);

// http://kb.mozillazine.org/Network.proxy.type
user_pref("network.proxy.type", 2); // [2: Proxy auto-configuration (PAC)]

// http://kb.mozillazine.org/Network.proxy.autoconfig_url
user_pref("network.proxy.autoconfig_url", "https://delannoy.web.cern.ch/proxy.pac");

// https://newscrewdriver.com/2023/10/02/make-firefox-pdf-viewer-default-to-page-fit-zoom/
// [How to configure firefox built-in pdf viewer](https://superuser.com/a/888856)
user_pref("pdfjs.defaultZoomValue", "page-width");

// https://old.reddit.com/r/firefox/comments/1c63uvc/disable_the_floating_highlight_button_on_pdfs/
user_pref('pdfjs.enableHighlightFloatingButton', false);

// https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#password-credit-card-and-address-management
user_pref("signon.rememberSignons", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// user_pref("startup-restore-windows-and-tabs", true);

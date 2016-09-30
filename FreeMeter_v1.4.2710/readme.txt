FreeMeter is a simple, friendly network monitoring and diagnosis tool, written in C# using the
MS .NET Framework 2.0 and Visual Studio 2005. Its primary function is to display graphically how much
data you are transfering over the network interfaces in your computer. It is also a handy tool for
tasks such as copying broken URLs to your browser, pinging and traceing other computers, and
watching for new email.

Check http://freemeter.sourceforge.net/ for latest version and contact information, CVS available to
developers, ask at the front desk.

See changelog.txt at above URL or in the source zip for version history.

FEATURES:
-Graph of bandwidth usage, show download only, upload only, or both.
-Iconified Graph of bandwidth usage in Systray allows hiding of main graph when it is an obstruction.
-Display units in bits or bytes or both.
-Totals Log
-Configurable connection speed (graph scale) and update interval.
-Monitor any or all network interfaces installed in your computer.
-Select colors and transparency of the graph.
-Choose to display DUMeter like icons in the systray (Thanks to Miechu. Also hoots to DUMeter, ive always loved this program.)
-View graph of last 24 hours stats.
-URL grabber watches clipboard for URLs, removes line breaks and opens them in your browser.
-Email notifier can check up to 5 POP/IMAP email accounts for new messages periodically.
-Graphic Ping and Traceroute utilities to help diagnose network problems.
-GPL license, free for all to use, check the About dialog in FreeMeter for license information.


INSTALLATION:
NOTE: New version settings are incompatible with older versions of freemeter.
      All setting were moved to xml file and will stay there.
  
FreeMeter requires Microsoft .Net Framework 2.0, which can be downloaded from Microsoft.
FreeMeter is a stand alone program, no installation is necessary, simply run the exe
or you may want to create a shortcut for it. You may also want to copy it to your Start menus
Startup folder if you want it to launch when windows starts up, or you login.

NOTES and TROUBLESHOOTING:
To restore default settings just delete config.xml while FreeMeter is not running.

If you want to try the latest version in CVS, which will contain all bugfixes and new features 
to date beyond the latest release (also features under development that may not work yet),
please see the CVS info link on http://freemeter.meta-forge.com . You will have to have to compile it,
however, since we do not include binaries in the CVS repository.

Color Cycling approximately doubles CPU usage, and appears to be the most significant waste of
memory available to you in this program. I think its fun tho. If you are having problems with
occasional crashes, try disabling Color Cycling (its off by default).

If you have difficulties with the Systray Icon getting hidden in windows XP you may right click
the task bar, choose properties, and adjust the icon hiding preferences by clicking the customize
button on that window.

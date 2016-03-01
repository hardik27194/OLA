

--package.path = ';;/data/data/com.lohool.ola/apps/lua/?.lua;'   
--package.cpath = '/data/data/com.lohool.ola/lua/?.so;'   --so

OLA={}
--applications' root directory,and which will be resolved to the real absolute path
--if OLA.app_server is defined, the real base is OLA.base..OLA.app_server, or it is OS_SANDBOX_PATH..OLA.base
--the OLA.base should not be modified once the application was installed, even in the next versions
OLA.base='apps/'

--esb base, check and download new versions from the base site
--OLA.esb="http://10.0.2.2:8080/mesb/"  --localhost when use simulator
--OLA.esb="http://192.168.0.101:8080/mesb/"

--app executable resources path. if it is local path of Android,it is in Assets folder.
--else runs on remote server, and the "reload" function is enabled
OLA.app_server="http://10.0.2.2:8080/"
--OLA.app_server="http://192.168.0.103:8080/"

OLA.mode="development" --"production" --development
--app's file storage on sdcard
OLA.storage='esb/'

--app's sandbox path of the platform 
OLA.app_path='.'

OLA.base_dpi=160

OLA.apps={}



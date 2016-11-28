--for IOS
--Log:d("OLA.lua Test","IOS")

--package.path = ';;assets/lua/?.lua;'   
--package.cpath = '/data/data/com.lohool.ola/lua/?.so;'   --so

OLA={}
--applications' root directory,and which will be injected with the real absolute path
--if OLA.app_server is defined, the real base is OLA.base..OLA.app_server, or it is OS_SANDBOX_PATH..OLA.base
--the OLA.base should not be modified once the application was installed, even in the next versions
OLA.base='assets/'


--esb base
--OLA.esb="http://10.0.2.2:8080/mesb/"
--OLA.esb="http://192.168.0.109:8080/mesb/"
--app executable resources path. if it is local path of Android,it is in Assets folder.
--if runs on remote server
--OLA.app_server="http://10.0.2.2:8080/"
OLA.app_server="http://192.168.0.106:8080/"

OLA.mode="development" --"production" --development
--app's file storage on sdcard
OLA.storage='Documents/app/'

--app's sandbox path of the platform 
OLA.app_path='.'

OLA.base_dpi=160

OLA.apps={}

--require "TestRequire"

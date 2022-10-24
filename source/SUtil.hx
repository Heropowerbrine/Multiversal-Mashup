package;

#if android
import android.Permissions;
import android.os.Build;
import android.os.Environment;
import android.widget.Toast;
#end
import flash.system.System;
import flixel.FlxG;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import openfl.utils.Assets;
#if (sys && !ios)
import sys.FileSystem;
import sys.io.File;
#end
	
using StringTools;

/**
 * ...
 * @author: Saw (M.A. Jigsaw)
 */
class SUtil
{
	/**
	 * A simple check function
	 */
	public static function check()
	{
		#if android
		if (!Permissions.getGrantedPermissions().contains(Permissions.WRITE_EXTERNAL_STORAGE)
			&& !Permissions.getGrantedPermissions().contains(Permissions.READ_EXTERNAL_STORAGE))
		{
			if (VERSION.SDK_INT > 23 || VERSION.SDK_INT == 23)
			{
				Permissions.requestPermissions([Permissions.WRITE_EXTERNAL_STORAGE, Permissions.READ_EXTERNAL_STORAGE]);

				/**
				 * Basically for now i can't force the app to stop while its requesting a android permission, so this makes the app to stop while its requesting the specific permission
				 */
				lib.application.current.window.alert('If you accepted the permissions you are all good!' + "\nIf you didn't then expect a crash"
					+ 'Press Ok to see what happens',
					'Permissions?');
			}
			else
			{
				lib.application.current.window.alert('Please grant the game storage permissions in app settings' + '\nPress Ok io close the app', 'Permissions?');
				System.exit(1);
			}
		}

		if (Permissions.getGrantedPermissions().contains(Permissions.WRITE_EXTERNAL_STORAGE)
			&& Permissions.getGrantedPermissions().contains(Permissions.READ_EXTERNAL_STORAGE))
		{
			if (!FileSystem.exists(SUtil.getPath()))
				FileSystem.createDirectory(SUtil.getPath());

			if (!FileSystem.exists(SUtil.getPath() + 'assets') && !FileSystem.exists(SUtil.getPath() + 'mods'))
			{
				lib.application.current.window.alert("Whoops, seems like you didn't extract the files from the .APK!\nPlease watch the tutorial by pressing OK.",
					'Error!');
				FlxG.openURL('https://youtu.be/zjvkTmdWvfU');
				System.exit(1);
			}
			else if ((FileSystem.exists(SUtil.getPath() + 'assets') && !FileSystem.isDirectory(SUtil.getPath() + 'assets'))
				&& (FileSystem.exists(SUtil.getPath() + 'mods') && !FileSystem.isDirectory(SUtil.getPath() + 'mods')))
			{
				lib.application.current.window.alert("Why did you create two files called assets and mods instead of copying the folders from the apk?, expect a crash.",
					'Error!');
				System.exit(1);
			}
			else
			{
				if (!FileSystem.exists(SUtil.getPath() + 'assets'))
				{
					lib.application.current.window.alert("Whoops, seems like you didn't extract the assets/assets folder from the .APK!\nPlease watch the tutorial by pressing OK.",
						'Error!');
					FlxG.openURL('https://youtu.be/zjvkTmdWvfU');
					System.exit(1);
				}
				else if (FileSystem.exists(SUtil.getPath() + 'assets') && !FileSystem.isDirectory(SUtil.getPath() + 'assets'))
				{
					lib.application.current.window.alert("Why did you create a file called assets instead of copying the assets directory from the apk?, expect a crash.",
						'Error!');
					System.exit(1);
				}

				if (!FileSystem.exists(SUtil.getPath() + 'mods'))
				{
					lib.application.current.window.alert("Whoops, seems like you didn't extract the assets/mods folder from the .APK!\nPlease watch the tutorial by pressing OK.",
						'Error!');
					FlxG.openURL('https://youtu.be/zjvkTmdWvfU');
					System.exit(1);
				}
				else if (FileSystem.exists(SUtil.getPath() + 'mods') && !FileSystem.isDirectory(SUtil.getPath() + 'mods'))
				{
					lib.application.current.window.alert("Why did you create a file called mods instead of copying the mods directory from the apk?, expect a crash.",
						'Error!');
					System.exit(1);
				}
			}
		}
		#end
	}

	/**
	 * This returns the external storage path that the game will use
	 */
	public static function getPath():String
	{
		#if android
		return Environment.getExternalStorageDirectory() + '/' + '.' + lib.application.current.meta.get('file') + '/';
		#else
		return '';
		#end
	}

	/**
	 * Uncaught error handler, original made by: sqirra-rng
	 */
	public static function uncaughtErrorHandler()
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(u:UncaughtErrorEvent)
		{
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var errMsg:String = '';

			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case CFunction:
						errMsg += 'a C function\n';
					case Module(m):
						errMsg += 'module ' + m + '\n';
					case FilePos(s, file, line, column):
						errMsg += file + ' (line ' + line + ')\n';
					case Method(cname, meth):
						errMsg += cname == null ? "<unknown>" : cname + '.' + meth + '\n';
					case LocalFunction(n):
						errMsg += 'local function ' + n + '\n';
				}
			}

			errMsg += u.error;

			#if (sys && !ios)
			try
			{
				if (!FileSystem.exists(SUtil.getPath() + 'logs'))
					FileSystem.createDirectory(SUtil.getPath() + 'logs');

				File.saveContent(SUtil.getPath()
					+ 'logs/'
					+ Lib.application.meta.get('file')
					+ '-'
					+ Date.now().toString().replace(' ', '-').replace(':', "'")
					+ '.log',
					errMsg
					+ '\n');
			}
			#if android
			catch (e:Dynamic)
			Toast.makeText("Error!\nClouldn't save the crash dump because:\n" + e, Toast.LENGTH_LONG);
			#end
			#end

			println(errMsg);
			Lib.application.window.alert(errMsg, 'Error!');
			System.exit(1);
		});
	}


	#if (sys && !ios)
	public static function saveContent(fileName:String = 'file', fileExtension:String = '.json',
			fileData:String = 'you forgot to add something in your code lol')
	{
		try
		{
			if (!FileSystem.exists(SUtil.getPath() + 'saves'))
				FileSystem.createDirectory(SUtil.getPath() + 'saves');

			File.saveContent(SUtil.getPath() + 'saves/' + fileName + fileExtension, fileData);
			#if android
			Toast.makeText("File Saved Successfully!", Toast.LENGTH_LONG);
			#end
		}
		#if android
		catch (e:Dynamic)
		Toast.makeText("Error!\nClouldn't save the file because:\n" + e, Toast.LENGTH_LONG);
		#end
	}

	public static function copyContent(copyPath:String, savePath:String)
	{
		try
		{
			if (!FileSystem.exists(savePath) && Assets.exists(copyPath))
				File.saveBytes(savePath, Assets.getBytes(copyPath));
		}
		#if android
		catch (e:Dynamic)
		Toast.makeText("Error!\nClouldn't copy the file because:\n" + e, Toast.LENGTH_LONG);
		#end
	}
	#end

	private static function println(msg:String):Void
	{
		#if sys
		Sys.println(msg);
		#else
		// Pass null to exclude the position.
		haxe.Log.trace(msg, null);
		#end
	}
}

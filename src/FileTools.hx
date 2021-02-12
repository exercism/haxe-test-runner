import sys.FileSystem as FS;

class FileTools {
	public static function deleteDirRecursively(path:String) {
		if (FS.exists(path) && FS.isDirectory(path)) {
			var entries = FS.readDirectory(path);
			for (entry in entries) {
				if (FS.isDirectory('$path/$entry')) {
					deleteDirRecursively('$path/$entry');
					FS.deleteDirectory('$path/$entry');
				} else
					FS.deleteFile('$path/$entry');
			}
			// delete root dir
			FS.deleteDirectory(path);
		}
	}
}

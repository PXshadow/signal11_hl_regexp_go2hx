package stdgo.io.fs;
import stdgo.StdGoTypes;
import stdgo.Error;
import stdgo.Go;
import stdgo.GoString;
import stdgo.Pointer;
import stdgo.Slice;
import stdgo.GoArray;
import stdgo.GoMap;
import stdgo.Chan;
/**
    // Package fs defines basic interfaces to a file system.
    // A file system can be provided by the host operating system
    // but also by other packages.
**/
private var __go2hxdoc__package : Bool;
/**
    // Generic file system errors.
    // Errors returned by file systems can be tested against these errors
    // using errors.Is.
    
    // "invalid argument"
**/
var errInvalid = _errInvalid();
/**
    // Generic file system errors.
    // Errors returned by file systems can be tested against these errors
    // using errors.Is.
    
    // "permission denied"
**/
var errPermission = _errPermission();
/**
    // Generic file system errors.
    // Errors returned by file systems can be tested against these errors
    // using errors.Is.
    
    // "file already exists"
**/
var errExist = _errExist();
/**
    // Generic file system errors.
    // Errors returned by file systems can be tested against these errors
    // using errors.Is.
    
    // "file does not exist"
**/
var errNotExist = _errNotExist();
/**
    // Generic file system errors.
    // Errors returned by file systems can be tested against these errors
    // using errors.Is.
    
    // "file already closed"
**/
var errClosed = _errClosed();
/**
    // SkipDir is used as a return value from WalkDirFuncs to indicate that
    // the directory named in the call is to be skipped. It is not returned
    // as an error by any function.
    
    
**/
var skipDir = stdgo.errors.Errors.new_(("skip this directory" : GoString));
/**
    // SkipAll is used as a return value from WalkDirFuncs to indicate that
    // all remaining files and directories are to be skipped. It is not returned
    // as an error by any function.
    
    
**/
var skipAll = stdgo.errors.Errors.new_(("skip everything and stop the walk" : GoString));
/**
    // The single letters are the abbreviations
    // used by the String method's formatting.
    
    // d: is a directory
**/
final modeDir : FileMode = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // a: append-only
**/
final modeAppend = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // l: exclusive use
**/
final modeExclusive = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // T: temporary file; Plan 9 only
**/
final modeTemporary = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // L: symbolic link
**/
final modeSymlink = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // D: device file
**/
final modeDevice = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // p: named pipe (FIFO)
**/
final modeNamedPipe = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // S: Unix domain socket
**/
final modeSocket = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // u: setuid
**/
final modeSetuid = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // g: setgid
**/
final modeSetgid = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // c: Unix character device, when ModeDevice is set
**/
final modeCharDevice = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // t: sticky
**/
final modeSticky = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // ?: non-regular file; nothing else is known about this file
**/
final modeIrregular = (524288u32 : stdgo.io.fs.Fs.FileMode);
/**
    // Mask for the type bits. For regular files, none will be set.
    
    
**/
final modeType = (-1893203968u32 : stdgo.io.fs.Fs.FileMode);
/**
    // The defined file mode bits are the most significant bits of the FileMode.
    // The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
    // The values of these bits should be considered part of the public API and
    // may be used in wire protocols or disk representations: they must not be
    // changed, although new bits might be added.
    
    // Unix permission bits
**/
final modePerm : FileMode = (511u32 : stdgo.io.fs.Fs.FileMode);
/**
    // An FS provides access to a hierarchical file system.
    //
    // The FS interface is the minimum implementation required of the file system.
    // A file system may implement additional interfaces,
    // such as ReadFileFS, to provide additional or optimized functionality.
    
    
**/
typedef FS = StructType & {
    /**
        // Open opens the named file.
        //
        // When Open returns an error, it should be of type *PathError
        // with the Op field set to "open", the Path field set to name,
        // and the Err field describing the problem.
        //
        // Open should reject attempts to open names that do not satisfy
        // ValidPath(name), returning a *PathError with Err set to
        // ErrInvalid or ErrNotExist.
        
        
    **/
    public dynamic function open(_name:GoString):{ var _0 : File; var _1 : Error; };
};
/**
    // A File provides access to a single file.
    // The File interface is the minimum implementation required of the file.
    // Directory files should also implement ReadDirFile.
    // A file may implement io.ReaderAt or io.Seeker as optimizations.
    
    
**/
typedef File = StructType & {
    /**
        
        
        
    **/
    public dynamic function stat():{ var _0 : FileInfo; var _1 : Error; };
    /**
        
        
        
    **/
    public dynamic function read(_0:Slice<GoByte>):{ var _0 : GoInt; var _1 : Error; };
    /**
        
        
        
    **/
    public dynamic function close():Error;
};
/**
    // A DirEntry is an entry read from a directory
    // (using the ReadDir function or a ReadDirFile's ReadDir method).
    
    
**/
typedef DirEntry = StructType & {
    /**
        // Name returns the name of the file (or subdirectory) described by the entry.
        // This name is only the final element of the path (the base name), not the entire path.
        // For example, Name would return "hello.go" not "home/gopher/hello.go".
        
        
    **/
    public dynamic function name():GoString;
    /**
        // IsDir reports whether the entry describes a directory.
        
        
    **/
    public dynamic function isDir():Bool;
    /**
        // Type returns the type bits for the entry.
        // The type bits are a subset of the usual FileMode bits, those returned by the FileMode.Type method.
        
        
    **/
    public dynamic function type():FileMode;
    /**
        // Info returns the FileInfo for the file or subdirectory described by the entry.
        // The returned FileInfo may be from the time of the original directory read
        // or from the time of the call to Info. If the file has been removed or renamed
        // since the directory read, Info may return an error satisfying errors.Is(err, ErrNotExist).
        // If the entry denotes a symbolic link, Info reports the information about the link itself,
        // not the link's target.
        
        
    **/
    public dynamic function info():{ var _0 : FileInfo; var _1 : Error; };
};
/**
    // A ReadDirFile is a directory file whose entries can be read with the ReadDir method.
    // Every directory file should implement this interface.
    // (It is permissible for any file to implement this interface,
    // but if so ReadDir should return an error for non-directories.)
    
    
**/
typedef ReadDirFile = StructType & {
    > File,
    /**
        // ReadDir reads the contents of the directory and returns
        // a slice of up to n DirEntry values in directory order.
        // Subsequent calls on the same file will yield further DirEntry values.
        //
        // If n > 0, ReadDir returns at most n DirEntry structures.
        // In this case, if ReadDir returns an empty slice, it will return
        // a non-nil error explaining why.
        // At the end of a directory, the error is io.EOF.
        // (ReadDir must return io.EOF itself, not an error wrapping io.EOF.)
        //
        // If n <= 0, ReadDir returns all the DirEntry values from the directory
        // in a single slice. In this case, if ReadDir succeeds (reads all the way
        // to the end of the directory), it returns the slice and a nil error.
        // If it encounters an error before the end of the directory,
        // ReadDir returns the DirEntry list read until that point and a non-nil error.
        
        
    **/
    public dynamic function readDir(_n:GoInt):{ var _0 : Slice<DirEntry>; var _1 : Error; };
};
/**
    // A FileInfo describes a file and is returned by Stat.
    
    
**/
typedef FileInfo = StructType & {
    /**
        
        
        // base name of the file
    **/
    public dynamic function name():GoString;
    /**
        
        
        // length in bytes for regular files; system-dependent for others
    **/
    public dynamic function size():GoInt64;
    /**
        
        
        // file mode bits
    **/
    public dynamic function mode():FileMode;
    /**
        
        
        // modification time
    **/
    public dynamic function modTime():stdgo.time.Time.Time;
    /**
        
        
        // abbreviation for Mode().IsDir()
    **/
    public dynamic function isDir():Bool;
    /**
        
        
        // underlying data source (can return nil)
    **/
    public dynamic function sys():AnyInterface;
};
/**
    // A GlobFS is a file system with a Glob method.
    
    
**/
typedef GlobFS = StructType & {
    > FS,
    /**
        // Glob returns the names of all files matching pattern,
        // providing an implementation of the top-level
        // Glob function.
        
        
    **/
    public dynamic function glob(_pattern:GoString):{ var _0 : Slice<GoString>; var _1 : Error; };
};
/**
    // ReadDirFS is the interface implemented by a file system
    // that provides an optimized implementation of ReadDir.
    
    
**/
typedef ReadDirFS = StructType & {
    > FS,
    /**
        // ReadDir reads the named directory
        // and returns a list of directory entries sorted by filename.
        
        
    **/
    public dynamic function readDir(_name:GoString):{ var _0 : Slice<DirEntry>; var _1 : Error; };
};
/**
    // ReadFileFS is the interface implemented by a file system
    // that provides an optimized implementation of ReadFile.
    
    
**/
typedef ReadFileFS = StructType & {
    > FS,
    /**
        // ReadFile reads the named file and returns its contents.
        // A successful call returns a nil error, not io.EOF.
        // (Because ReadFile reads the whole file, the expected EOF
        // from the final Read is not treated as an error to be reported.)
        //
        // The caller is permitted to modify the returned byte slice.
        // This method should return a copy of the underlying data.
        
        
    **/
    public dynamic function readFile(_name:GoString):{ var _0 : Slice<GoByte>; var _1 : Error; };
};
/**
    // A StatFS is a file system with a Stat method.
    
    
**/
typedef StatFS = StructType & {
    > FS,
    /**
        // Stat returns a FileInfo describing the file.
        // If there is an error, it should be of type *PathError.
        
        
    **/
    public dynamic function stat(_name:GoString):{ var _0 : FileInfo; var _1 : Error; };
};
/**
    // A SubFS is a file system with a Sub method.
    
    
**/
typedef SubFS = StructType & {
    > FS,
    /**
        // Sub returns an FS corresponding to the subtree rooted at dir.
        
        
    **/
    public dynamic function sub(_dir:GoString):{ var _0 : FS; var _1 : Error; };
};
/**
    
    
    
**/
private typedef T__interface_0 = StructType & {
    /**
        
        
        
    **/
    public dynamic function timeout():Bool;
};
/**
    // PathError records an error and the operation and file path that caused it.
    
    
**/
@:structInit @:using(stdgo.io.fs.Fs.PathError_static_extension) class PathError {
    public var op : GoString = "";
    public var path : GoString = "";
    public var err : Error = (null : Error);
    public function new(?op:GoString, ?path:GoString, ?err:Error) {
        if (op != null) this.op = op;
        if (path != null) this.path = path;
        if (err != null) this.err = err;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new PathError(op, path, err);
    }
}
/**
    // dirInfo is a DirEntry based on a FileInfo.
    
    
**/
@:structInit @:private @:using(stdgo.io.fs.Fs.T_dirInfo_static_extension) class T_dirInfo {
    public var _fileInfo : stdgo.io.fs.Fs.FileInfo = (null : stdgo.io.fs.Fs.FileInfo);
    public function new(?_fileInfo:stdgo.io.fs.Fs.FileInfo) {
        if (_fileInfo != null) this._fileInfo = _fileInfo;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_dirInfo(_fileInfo);
    }
}
/**
    
    
    
**/
@:structInit @:private @:using(stdgo.io.fs.Fs.T_subFS_static_extension) class T_subFS {
    public var _fsys : stdgo.io.fs.Fs.FS = (null : stdgo.io.fs.Fs.FS);
    public var _dir : GoString = "";
    public function new(?_fsys:stdgo.io.fs.Fs.FS, ?_dir:GoString) {
        if (_fsys != null) this._fsys = _fsys;
        if (_dir != null) this._dir = _dir;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_subFS(_fsys, _dir);
    }
}
/**
    
    
    
**/
@:structInit @:private @:using(stdgo.io.fs.Fs.T_statDirEntry_static_extension) class T_statDirEntry {
    public var _info : stdgo.io.fs.Fs.FileInfo = (null : stdgo.io.fs.Fs.FileInfo);
    public function new(?_info:stdgo.io.fs.Fs.FileInfo) {
        if (_info != null) this._info = _info;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_statDirEntry(_info);
    }
}
/**
    // A FileMode represents a file's mode and permission bits.
    // The bits have the same definition on all systems, so that
    // information about files can be moved from one system
    // to another portably. Not all bits apply to all systems.
    // The only required bit is ModeDir for directories.
**/
@:named @:using(stdgo.io.fs.Fs.FileMode_static_extension) typedef FileMode = GoUInt32;
/**
    // WalkDirFunc is the type of the function called by WalkDir to visit
    // each file or directory.
    //
    // The path argument contains the argument to WalkDir as a prefix.
    // That is, if WalkDir is called with root argument "dir" and finds a file
    // named "a" in that directory, the walk function will be called with
    // argument "dir/a".
    //
    // The d argument is the fs.DirEntry for the named path.
    //
    // The error result returned by the function controls how WalkDir
    // continues. If the function returns the special value SkipDir, WalkDir
    // skips the current directory (path if d.IsDir() is true, otherwise
    // path's parent directory). If the function returns the special value
    // SkipAll, WalkDir skips all remaining files and directories. Otherwise,
    // if the function returns a non-nil error, WalkDir stops entirely and
    // returns that error.
    //
    // The err argument reports an error related to path, signaling that
    // WalkDir will not walk into that directory. The function can decide how
    // to handle that error; as described earlier, returning the error will
    // cause WalkDir to stop walking the entire tree.
    //
    // WalkDir calls the function with a non-nil err argument in two cases.
    //
    // First, if the initial fs.Stat on the root directory fails, WalkDir
    // calls the function with path set to root, d set to nil, and err set to
    // the error from fs.Stat.
    //
    // Second, if a directory's ReadDir method fails, WalkDir calls the
    // function with path set to the directory's path, d set to an
    // fs.DirEntry describing the directory, and err set to the error from
    // ReadDir. In this second case, the function is called twice with the
    // path of the directory: the first call is before the directory read is
    // attempted and has err set to nil, giving the function a chance to
    // return SkipDir or SkipAll and avoid the ReadDir entirely. The second call
    // is after a failed ReadDir and reports the error from ReadDir.
    // (If ReadDir succeeds, there is no second call.)
    //
    // The differences between WalkDirFunc compared to filepath.WalkFunc are:
    //
    //   - The second argument has type fs.DirEntry instead of fs.FileInfo.
    //   - The function is called before reading a directory, to allow SkipDir
    //     or SkipAll to bypass the directory read entirely or skip all remaining
    //     files and directories respectively.
    //   - If a directory read fails, the function is called a second time
    //     for that directory to report the error.
**/
@:named typedef WalkDirFunc = (GoString, stdgo.io.fs.Fs.DirEntry, Error) -> Error;
/**
    // ValidPath reports whether the given path name
    // is valid for use in a call to Open.
    //
    // Path names passed to open are UTF-8-encoded,
    // unrooted, slash-separated sequences of path elements, like “x/y/z”.
    // Path names must not contain an element that is “.” or “..” or the empty string,
    // except for the special case that the root directory is named “.”.
    // Paths must not start or end with a slash: “/x” and “x/” are invalid.
    //
    // Note that paths are slash-separated on all systems, even Windows.
    // Paths containing other characters such as backslash and colon
    // are accepted as valid, but those characters must never be
    // interpreted by an FS implementation as path element separators.
**/
function validPath(_name:GoString):Bool {
        if (!stdgo.unicode.utf8.Utf8.validString(_name)) {
            return false;
        };
        if (_name == (("." : GoString))) {
            return true;
        };
        while (true) {
            var _i:GoInt = (0 : GoInt);
            while ((_i < _name.length) && (_name[(_i : GoInt)] != (47 : GoUInt8))) {
                _i++;
            };
            var _elem:GoString = (_name.__slice__(0, _i) : GoString);
            if (((_elem == Go.str()) || (_elem == ("." : GoString))) || (_elem == (".." : GoString))) {
                return false;
            };
            if (_i == ((_name.length))) {
                return true;
            };
            _name = (_name.__slice__(_i + (1 : GoInt)) : GoString);
        };
    }
private function _errInvalid():Error {
        return stdgo.internal.oserror.Oserror.errInvalid;
    }
private function _errPermission():Error {
        return stdgo.internal.oserror.Oserror.errPermission;
    }
private function _errExist():Error {
        return stdgo.internal.oserror.Oserror.errExist;
    }
private function _errNotExist():Error {
        return stdgo.internal.oserror.Oserror.errNotExist;
    }
private function _errClosed():Error {
        return stdgo.internal.oserror.Oserror.errClosed;
    }
/**
    // Glob returns the names of all files matching pattern or nil
    // if there is no matching file. The syntax of patterns is the same
    // as in path.Match. The pattern may describe hierarchical names such as
    // usr/|*|/bin/ed.
    //
    // Glob ignores file system errors such as I/O errors reading directories.
    // The only possible returned error is path.ErrBadPattern, reporting that
    // the pattern is malformed.
    //
    // If fs implements GlobFS, Glob calls fs.Glob.
    // Otherwise, Glob uses ReadDir to traverse the directory tree
    // and look for matches for the pattern.
**/
function glob(_fsys:FS, _pattern:GoString):{ var _0 : Slice<GoString>; var _1 : Error; } {
        var _matches:Slice<GoString> = (null : Slice<GoString>), _err:Error = (null : Error);
        return _globWithLimit(_fsys, _pattern, (0 : GoInt));
    }
private function _globWithLimit(_fsys:FS, _pattern:GoString, _depth:GoInt):{ var _0 : Slice<GoString>; var _1 : Error; } {
        var _matches:Slice<GoString> = (null : Slice<GoString>), _err:Error = (null : Error);
        {};
        if (_depth > (10000 : GoInt)) {
            return { _0 : (null : Slice<GoString>), _1 : stdgo.path.Path.errBadPattern };
        };
        {
            var __tmp__ = try {
                { value : (Go.typeAssert((Go.toInterface(_fsys) : GlobFS)) : GlobFS), ok : true };
            } catch(_) {
                { value : (null : stdgo.io.fs.Fs.GlobFS), ok : false };
            }, _fsys = __tmp__.value, _ok = __tmp__.ok;
            if (_ok) {
                return _fsys.glob(_pattern);
            };
        };
        {
            var __tmp__ = stdgo.path.Path.match(_pattern, Go.str()), __0:Bool = __tmp__._0, _err:Error = __tmp__._1;
            if (_err != null) {
                return { _0 : (null : Slice<GoString>), _1 : _err };
            };
        };
        if (!_hasMeta(_pattern)) {
            {
                {
                    var __tmp__ = stat(_fsys, _pattern);
                    _err = __tmp__._1;
                };
                if (_err != null) {
                    return { _0 : (null : Slice<GoString>), _1 : (null : Error) };
                };
            };
            return { _0 : (new Slice<GoString>(0, 0, _pattern) : Slice<GoString>), _1 : (null : Error) };
        };
        var __tmp__ = stdgo.path.Path.split(_pattern), _dir:GoString = __tmp__._0, _file:GoString = __tmp__._1;
        _dir = _cleanGlobPath(_dir);
        if (!_hasMeta(_dir)) {
            return _glob(_fsys, _dir, _file, (null : Slice<GoString>));
        };
        if (_dir == (_pattern)) {
            return { _0 : (null : Slice<GoString>), _1 : stdgo.path.Path.errBadPattern };
        };
        var _m:Slice<GoString> = (null : Slice<GoString>);
        {
            var __tmp__ = _globWithLimit(_fsys, _dir, _depth + (1 : GoInt));
            _m = __tmp__._0;
            _err = __tmp__._1;
        };
        if (_err != null) {
            return { _0 : (null : Slice<GoString>), _1 : _err };
        };
        for (__1 => _d in _m) {
            {
                var __tmp__ = _glob(_fsys, _d, _file, _matches);
                _matches = __tmp__._0;
                _err = __tmp__._1;
            };
            if (_err != null) {
                return { _0 : _matches, _1 : _err };
            };
        };
        return { _0 : _matches, _1 : _err };
    }
/**
    // cleanGlobPath prepares path for glob matching.
**/
private function _cleanGlobPath(_path:GoString):GoString {
        {
            final __value__ = _path;
            if (__value__ == (Go.str())) {
                return ("." : GoString);
            } else {
                return (_path.__slice__((0 : GoInt), (_path.length) - (1 : GoInt)) : GoString);
            };
        };
    }
/**
    // glob searches for files matching pattern in the directory dir
    // and appends them to matches, returning the updated slice.
    // If the directory cannot be opened, glob returns the existing matches.
    // New matches are added in lexicographical order.
**/
private function _glob(_fs:FS, _dir:GoString, _pattern:GoString, _matches:Slice<GoString>):{ var _0 : Slice<GoString>; var _1 : Error; } {
        var _m:Slice<GoString> = (null : Slice<GoString>), _e:Error = (null : Error);
        _m = _matches;
        var __tmp__ = readDir(_fs, _dir), _infos:Slice<stdgo.io.fs.Fs.DirEntry> = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : _m, _1 : _e };
        };
        for (__0 => _info in _infos) {
            var _n:GoString = _info.name();
            var __tmp__ = stdgo.path.Path.match(_pattern, _n), _matched:Bool = __tmp__._0, _err:Error = __tmp__._1;
            if (_err != null) {
                return { _0 : _m, _1 : _err };
            };
            if (_matched) {
                _m = (_m.__append__(stdgo.path.Path.join(_dir, _n)));
            };
        };
        return { _0 : _m, _1 : _e };
    }
/**
    // hasMeta reports whether path contains any of the magic characters
    // recognized by path.Match.
**/
private function _hasMeta(_path:GoString):Bool {
        {
            var _i:GoInt = (0 : GoInt);
            Go.cfor(_i < (_path.length), _i++, {
                {
                    final __value__ = _path[(_i : GoInt)];
                    if (__value__ == ((42 : GoUInt8)) || __value__ == ((63 : GoUInt8)) || __value__ == ((91 : GoUInt8)) || __value__ == ((92 : GoUInt8))) {
                        return true;
                    };
                };
            });
        };
        return false;
    }
/**
    // ReadDir reads the named directory
    // and returns a list of directory entries sorted by filename.
    //
    // If fs implements ReadDirFS, ReadDir calls fs.ReadDir.
    // Otherwise ReadDir calls fs.Open and uses ReadDir and Close
    // on the returned file.
**/
function readDir(_fsys:FS, _name:GoString):{ var _0 : Slice<DirEntry>; var _1 : Error; } {
        var __deferstack__:Array<Void -> Void> = [];
        {
            var __tmp__ = try {
                { value : (Go.typeAssert((Go.toInterface(_fsys) : ReadDirFS)) : ReadDirFS), ok : true };
            } catch(_) {
                { value : (null : stdgo.io.fs.Fs.ReadDirFS), ok : false };
            }, _fsys = __tmp__.value, _ok = __tmp__.ok;
            if (_ok) {
                return _fsys.readDir(_name);
            };
        };
        var __tmp__ = _fsys.open(_name), _file:stdgo.io.fs.Fs.File = __tmp__._0, _err:Error = __tmp__._1;
        try {
            if (_err != null) {
                return { _0 : (null : Slice<stdgo.io.fs.Fs.DirEntry>), _1 : _err };
            };
            __deferstack__.unshift(() -> _file.close());
            var __tmp__ = try {
                { value : (Go.typeAssert((Go.toInterface(_file) : ReadDirFile)) : ReadDirFile), ok : true };
            } catch(_) {
                { value : (null : stdgo.io.fs.Fs.ReadDirFile), ok : false };
            }, _dir = __tmp__.value, _ok = __tmp__.ok;
            if (!_ok) {
                {
                    for (defer in __deferstack__) {
                        defer();
                    };
                    return { _0 : (null : Slice<stdgo.io.fs.Fs.DirEntry>), _1 : Go.asInterface((Go.setRef(({ op : ("readdir" : GoString), path : _name, err : stdgo.errors.Errors.new_(("not implemented" : GoString)) } : PathError)) : Ref<stdgo.io.fs.Fs.PathError>)) };
                };
            };
            var __tmp__ = _dir.readDir((-1 : GoInt)), _list:Slice<stdgo.io.fs.Fs.DirEntry> = __tmp__._0, _err:Error = __tmp__._1;
            stdgo.sort.Sort.slice(Go.toInterface(_list), function(_i:GoInt, _j:GoInt):Bool {
                return _list[(_i : GoInt)].name() < _list[(_j : GoInt)].name();
            });
            {
                for (defer in __deferstack__) {
                    defer();
                };
                return { _0 : _list, _1 : _err };
            };
            for (defer in __deferstack__) {
                defer();
            };
            {
                for (defer in __deferstack__) {
                    defer();
                };
                if (Go.recover_exception != null) throw Go.recover_exception;
                return { _0 : (null : Slice<stdgo.io.fs.Fs.DirEntry>), _1 : (null : Error) };
            };
        } catch(__exception__) {
            var exe:Dynamic = __exception__.native;
            if ((exe is haxe.ValueException)) exe = exe.value;
            if (!(exe is AnyInterfaceData)) {
                exe = Go.toInterface(__exception__.message);
            };
            Go.recover_exception = exe;
            for (defer in __deferstack__) {
                defer();
            };
            if (Go.recover_exception != null) throw Go.recover_exception;
            return { _0 : (null : Slice<stdgo.io.fs.Fs.DirEntry>), _1 : (null : Error) };
        };
    }
/**
    // FileInfoToDirEntry returns a DirEntry that returns information from info.
    // If info is nil, FileInfoToDirEntry returns nil.
**/
function fileInfoToDirEntry(_info:FileInfo):DirEntry {
        if (_info == null) {
            return (null : stdgo.io.fs.Fs.DirEntry);
        };
        return Go.asInterface(({ _fileInfo : _info } : T_dirInfo));
    }
/**
    // ReadFile reads the named file from the file system fs and returns its contents.
    // A successful call returns a nil error, not io.EOF.
    // (Because ReadFile reads the whole file, the expected EOF
    // from the final Read is not treated as an error to be reported.)
    //
    // If fs implements ReadFileFS, ReadFile calls fs.ReadFile.
    // Otherwise ReadFile calls fs.Open and uses Read and Close
    // on the returned file.
**/
function readFile(_fsys:FS, _name:GoString):{ var _0 : Slice<GoByte>; var _1 : Error; } {
        var __deferstack__:Array<Void -> Void> = [];
        {
            var __tmp__ = try {
                { value : (Go.typeAssert((Go.toInterface(_fsys) : ReadFileFS)) : ReadFileFS), ok : true };
            } catch(_) {
                { value : (null : stdgo.io.fs.Fs.ReadFileFS), ok : false };
            }, _fsys = __tmp__.value, _ok = __tmp__.ok;
            if (_ok) {
                return _fsys.readFile(_name);
            };
        };
        var __tmp__ = _fsys.open(_name), _file:stdgo.io.fs.Fs.File = __tmp__._0, _err:Error = __tmp__._1;
        try {
            if (_err != null) {
                return { _0 : (null : Slice<GoUInt8>), _1 : _err };
            };
            __deferstack__.unshift(() -> _file.close());
            var _size:GoInt = (0 : GoInt);
            {
                var __tmp__ = _file.stat(), _info:stdgo.io.fs.Fs.FileInfo = __tmp__._0, _err:Error = __tmp__._1;
                if (_err == null) {
                    var _size64:GoInt64 = _info.size();
                    if (((_size64 : GoInt) : GoInt64) == (_size64)) {
                        _size = (_size64 : GoInt);
                    };
                };
            };
            var _data = new Slice<GoUInt8>((0 : GoInt).toBasic(), _size + (1 : GoInt)).__setNumber32__();
            while (true) {
                if ((_data.length) >= _data.capacity) {
                    var _d = ((_data.__slice__(0, _data.capacity) : Slice<GoUInt8>).__append__((0 : GoUInt8)));
                    _data = (_d.__slice__(0, (_data.length)) : Slice<GoUInt8>);
                };
                var __tmp__ = _file.read((_data.__slice__((_data.length), _data.capacity) : Slice<GoUInt8>)), _n:GoInt = __tmp__._0, _err:Error = __tmp__._1;
                _data = (_data.__slice__(0, (_data.length) + _n) : Slice<GoUInt8>);
                if (_err != null) {
                    if (Go.toInterface(_err) == (Go.toInterface(stdgo.io.Io.eof))) {
                        _err = (null : Error);
                    };
                    {
                        for (defer in __deferstack__) {
                            defer();
                        };
                        return { _0 : _data, _1 : _err };
                    };
                };
            };
            for (defer in __deferstack__) {
                defer();
            };
            {
                for (defer in __deferstack__) {
                    defer();
                };
                if (Go.recover_exception != null) throw Go.recover_exception;
                return { _0 : (null : Slice<GoUInt8>), _1 : (null : Error) };
            };
        } catch(__exception__) {
            var exe:Dynamic = __exception__.native;
            if ((exe is haxe.ValueException)) exe = exe.value;
            if (!(exe is AnyInterfaceData)) {
                exe = Go.toInterface(__exception__.message);
            };
            Go.recover_exception = exe;
            for (defer in __deferstack__) {
                defer();
            };
            if (Go.recover_exception != null) throw Go.recover_exception;
            return { _0 : (null : Slice<GoUInt8>), _1 : (null : Error) };
        };
    }
/**
    // Stat returns a FileInfo describing the named file from the file system.
    //
    // If fs implements StatFS, Stat calls fs.Stat.
    // Otherwise, Stat opens the file to stat it.
**/
function stat(_fsys:FS, _name:GoString):{ var _0 : FileInfo; var _1 : Error; } {
        var __deferstack__:Array<Void -> Void> = [];
        {
            var __tmp__ = try {
                { value : (Go.typeAssert((Go.toInterface(_fsys) : StatFS)) : StatFS), ok : true };
            } catch(_) {
                { value : (null : stdgo.io.fs.Fs.StatFS), ok : false };
            }, _fsys = __tmp__.value, _ok = __tmp__.ok;
            if (_ok) {
                return _fsys.stat(_name);
            };
        };
        var __tmp__ = _fsys.open(_name), _file:stdgo.io.fs.Fs.File = __tmp__._0, _err:Error = __tmp__._1;
        try {
            if (_err != null) {
                return { _0 : (null : stdgo.io.fs.Fs.FileInfo), _1 : _err };
            };
            __deferstack__.unshift(() -> _file.close());
            {
                for (defer in __deferstack__) {
                    defer();
                };
                return _file.stat();
            };
            for (defer in __deferstack__) {
                defer();
            };
            {
                for (defer in __deferstack__) {
                    defer();
                };
                if (Go.recover_exception != null) throw Go.recover_exception;
                return { _0 : (null : stdgo.io.fs.Fs.FileInfo), _1 : (null : Error) };
            };
        } catch(__exception__) {
            var exe:Dynamic = __exception__.native;
            if ((exe is haxe.ValueException)) exe = exe.value;
            if (!(exe is AnyInterfaceData)) {
                exe = Go.toInterface(__exception__.message);
            };
            Go.recover_exception = exe;
            for (defer in __deferstack__) {
                defer();
            };
            if (Go.recover_exception != null) throw Go.recover_exception;
            return { _0 : (null : stdgo.io.fs.Fs.FileInfo), _1 : (null : Error) };
        };
    }
/**
    // Sub returns an FS corresponding to the subtree rooted at fsys's dir.
    //
    // If dir is ".", Sub returns fsys unchanged.
    // Otherwise, if fs implements SubFS, Sub returns fsys.Sub(dir).
    // Otherwise, Sub returns a new FS implementation sub that,
    // in effect, implements sub.Open(name) as fsys.Open(path.Join(dir, name)).
    // The implementation also translates calls to ReadDir, ReadFile, and Glob appropriately.
    //
    // Note that Sub(os.DirFS("/"), "prefix") is equivalent to os.DirFS("/prefix")
    // and that neither of them guarantees to avoid operating system
    // accesses outside "/prefix", because the implementation of os.DirFS
    // does not check for symbolic links inside "/prefix" that point to
    // other directories. That is, os.DirFS is not a general substitute for a
    // chroot-style security mechanism, and Sub does not change that fact.
**/
function sub(_fsys:FS, _dir:GoString):{ var _0 : FS; var _1 : Error; } {
        if (!validPath(_dir)) {
            return { _0 : (null : stdgo.io.fs.Fs.FS), _1 : Go.asInterface((Go.setRef(({ op : ("sub" : GoString), path : _dir, err : stdgo.errors.Errors.new_(("invalid name" : GoString)) } : PathError)) : Ref<stdgo.io.fs.Fs.PathError>)) };
        };
        if (_dir == (("." : GoString))) {
            return { _0 : _fsys, _1 : (null : Error) };
        };
        {
            var __tmp__ = try {
                { value : (Go.typeAssert((Go.toInterface(_fsys) : SubFS)) : SubFS), ok : true };
            } catch(_) {
                { value : (null : stdgo.io.fs.Fs.SubFS), ok : false };
            }, _fsys = __tmp__.value, _ok = __tmp__.ok;
            if (_ok) {
                return _fsys.sub(_dir);
            };
        };
        return { _0 : Go.asInterface((Go.setRef((new T_subFS(_fsys, _dir) : T_subFS)) : Ref<stdgo.io.fs.Fs.T_subFS>)), _1 : (null : Error) };
    }
/**
    // walkDir recursively descends path, calling walkDirFn.
**/
private function _walkDir(_fsys:FS, _name:GoString, _d:DirEntry, _walkDirFn:WalkDirFunc):Error {
        {
            var _err:Error = _walkDirFn(_name, _d, (null : Error));
            if ((_err != null) || !_d.isDir()) {
                if ((Go.toInterface(_err) == Go.toInterface(skipDir)) && _d.isDir()) {
                    _err = (null : Error);
                };
                return _err;
            };
        };
        var __tmp__ = readDir(_fsys, _name), _dirs:Slice<stdgo.io.fs.Fs.DirEntry> = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            _err = _walkDirFn(_name, _d, _err);
            if (_err != null) {
                if ((Go.toInterface(_err) == Go.toInterface(skipDir)) && _d.isDir()) {
                    _err = (null : Error);
                };
                return _err;
            };
        };
        for (__0 => _d1 in _dirs) {
            var _name1:GoString = stdgo.path.Path.join(_name, _d1.name());
            {
                var _err:Error = _walkDir(_fsys, _name1, _d1, _walkDirFn);
                if (_err != null) {
                    if (Go.toInterface(_err) == (Go.toInterface(skipDir))) {
                        break;
                    };
                    return _err;
                };
            };
        };
        return (null : Error);
    }
/**
    // WalkDir walks the file tree rooted at root, calling fn for each file or
    // directory in the tree, including root.
    //
    // All errors that arise visiting files and directories are filtered by fn:
    // see the fs.WalkDirFunc documentation for details.
    //
    // The files are walked in lexical order, which makes the output deterministic
    // but requires WalkDir to read an entire directory into memory before proceeding
    // to walk that directory.
    //
    // WalkDir does not follow symbolic links found in directories,
    // but if root itself is a symbolic link, its target will be walked.
**/
function walkDir(_fsys:FS, _root:GoString, _fn:WalkDirFunc):Error {
        var __tmp__ = stat(_fsys, _root), _info:stdgo.io.fs.Fs.FileInfo = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            _err = _fn(_root, (null : stdgo.io.fs.Fs.DirEntry), _err);
        } else {
            _err = _walkDir(_fsys, _root, Go.asInterface((Go.setRef((new T_statDirEntry(_info) : T_statDirEntry)) : Ref<stdgo.io.fs.Fs.T_statDirEntry>)), _fn);
        };
        if ((Go.toInterface(_err) == Go.toInterface(skipDir)) || (Go.toInterface(_err) == Go.toInterface(skipAll))) {
            return (null : Error);
        };
        return _err;
    }
class PathError_asInterface {
    /**
        // Timeout reports whether this error represents a timeout.
    **/
    @:keep
    public dynamic function timeout():Bool return __self__.value.timeout();
    @:keep
    public dynamic function unwrap():Error return __self__.value.unwrap();
    @:keep
    public dynamic function error():GoString return __self__.value.error();
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<PathError>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.io.fs.Fs.PathError_asInterface) class PathError_static_extension {
    /**
        // Timeout reports whether this error represents a timeout.
    **/
    @:keep
    static public function timeout( _e:Ref<PathError>):Bool {
        var __tmp__ = try {
            { value : (Go.typeAssert((Go.toInterface(_e.err) : T__interface_0)) : T__interface_0), ok : true };
        } catch(_) {
            { value : (null : stdgo.io.fs.Fs.T__interface_0), ok : false };
        }, _t = __tmp__.value, _ok = __tmp__.ok;
        return _ok && _t.timeout();
    }
    @:keep
    static public function unwrap( _e:Ref<PathError>):Error {
        return _e.err;
    }
    @:keep
    static public function error( _e:Ref<PathError>):GoString {
        return (((_e.op + (" " : GoString)) + _e.path) + (": " : GoString)) + _e.err.error();
    }
}
class T_dirInfo_asInterface {
    @:keep
    public dynamic function name():GoString return __self__.value.name();
    @:keep
    public dynamic function info():{ var _0 : FileInfo; var _1 : Error; } return __self__.value.info();
    @:keep
    public dynamic function type():FileMode return __self__.value.type();
    @:keep
    public dynamic function isDir():Bool return __self__.value.isDir();
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_dirInfo>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.io.fs.Fs.T_dirInfo_asInterface) class T_dirInfo_static_extension {
    @:keep
    static public function name( _di:T_dirInfo):GoString {
        return _di._fileInfo.name();
    }
    @:keep
    static public function info( _di:T_dirInfo):{ var _0 : FileInfo; var _1 : Error; } {
        return { _0 : _di._fileInfo, _1 : (null : Error) };
    }
    @:keep
    static public function type( _di:T_dirInfo):FileMode {
        return _di._fileInfo.mode().type();
    }
    @:keep
    static public function isDir( _di:T_dirInfo):Bool {
        return _di._fileInfo.isDir();
    }
}
class T_subFS_asInterface {
    @:keep
    public dynamic function sub(_dir:GoString):{ var _0 : FS; var _1 : Error; } return __self__.value.sub(_dir);
    @:keep
    public dynamic function glob(_pattern:GoString):{ var _0 : Slice<GoString>; var _1 : Error; } return __self__.value.glob(_pattern);
    @:keep
    public dynamic function readFile(_name:GoString):{ var _0 : Slice<GoByte>; var _1 : Error; } return __self__.value.readFile(_name);
    @:keep
    public dynamic function readDir(_name:GoString):{ var _0 : Slice<DirEntry>; var _1 : Error; } return __self__.value.readDir(_name);
    @:keep
    public dynamic function open(_name:GoString):{ var _0 : File; var _1 : Error; } return __self__.value.open(_name);
    /**
        // fixErr shortens any reported names in PathErrors by stripping f.dir.
    **/
    @:keep
    public dynamic function _fixErr(_err:Error):Error return __self__.value._fixErr(_err);
    /**
        // shorten maps name, which should start with f.dir, back to the suffix after f.dir.
    **/
    @:keep
    public dynamic function _shorten(_name:GoString):{ var _0 : GoString; var _1 : Bool; } return __self__.value._shorten(_name);
    /**
        // fullName maps name to the fully-qualified name dir/name.
    **/
    @:keep
    public dynamic function _fullName(_op:GoString, _name:GoString):{ var _0 : GoString; var _1 : Error; } return __self__.value._fullName(_op, _name);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_subFS>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.io.fs.Fs.T_subFS_asInterface) class T_subFS_static_extension {
    @:keep
    static public function sub( _f:Ref<T_subFS>, _dir:GoString):{ var _0 : FS; var _1 : Error; } {
        if (_dir == (("." : GoString))) {
            return { _0 : Go.asInterface(_f), _1 : (null : Error) };
        };
        var __tmp__ = _f._fullName(("sub" : GoString), _dir), _full:GoString = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : (null : stdgo.io.fs.Fs.FS), _1 : _err };
        };
        return { _0 : Go.asInterface((Go.setRef((new T_subFS(_f._fsys, _full) : T_subFS)) : Ref<stdgo.io.fs.Fs.T_subFS>)), _1 : (null : Error) };
    }
    @:keep
    static public function glob( _f:Ref<T_subFS>, _pattern:GoString):{ var _0 : Slice<GoString>; var _1 : Error; } {
        {
            var __tmp__ = stdgo.path.Path.match(_pattern, Go.str()), __0:Bool = __tmp__._0, _err:Error = __tmp__._1;
            if (_err != null) {
                return { _0 : (null : Slice<GoString>), _1 : _err };
            };
        };
        if (_pattern == (("." : GoString))) {
            return { _0 : (new Slice<GoString>(0, 0, ("." : GoString)) : Slice<GoString>), _1 : (null : Error) };
        };
        var _full:GoString = (_f._dir + ("/" : GoString)) + _pattern;
        var __tmp__ = stdgo.io.fs.Fs.glob(_f._fsys, _full), _list:Slice<GoString> = __tmp__._0, _err:Error = __tmp__._1;
        for (_i => _name in _list) {
            var __tmp__ = _f._shorten(_name), _name:GoString = __tmp__._0, _ok:Bool = __tmp__._1;
            if (!_ok) {
                return { _0 : (null : Slice<GoString>), _1 : stdgo.errors.Errors.new_(((("invalid result from inner fsys Glob: " : GoString) + _name) + (" not in " : GoString)) + _f._dir) };
            };
            _list[(_i : GoInt)] = _name;
        };
        return { _0 : _list, _1 : _f._fixErr(_err) };
    }
    @:keep
    static public function readFile( _f:Ref<T_subFS>, _name:GoString):{ var _0 : Slice<GoByte>; var _1 : Error; } {
        var __tmp__ = _f._fullName(("read" : GoString), _name), _full:GoString = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : (null : Slice<GoUInt8>), _1 : _err };
        };
        var __tmp__ = stdgo.io.fs.Fs.readFile(_f._fsys, _full), _data:Slice<GoUInt8> = __tmp__._0, _err:Error = __tmp__._1;
        return { _0 : _data, _1 : _f._fixErr(_err) };
    }
    @:keep
    static public function readDir( _f:Ref<T_subFS>, _name:GoString):{ var _0 : Slice<DirEntry>; var _1 : Error; } {
        var __tmp__ = _f._fullName(("read" : GoString), _name), _full:GoString = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : (null : Slice<stdgo.io.fs.Fs.DirEntry>), _1 : _err };
        };
        var __tmp__ = stdgo.io.fs.Fs.readDir(_f._fsys, _full), _dir:Slice<stdgo.io.fs.Fs.DirEntry> = __tmp__._0, _err:Error = __tmp__._1;
        return { _0 : _dir, _1 : _f._fixErr(_err) };
    }
    @:keep
    static public function open( _f:Ref<T_subFS>, _name:GoString):{ var _0 : File; var _1 : Error; } {
        var __tmp__ = _f._fullName(("open" : GoString), _name), _full:GoString = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : (null : stdgo.io.fs.Fs.File), _1 : _err };
        };
        var __tmp__ = _f._fsys.open(_full), _file:stdgo.io.fs.Fs.File = __tmp__._0, _err:Error = __tmp__._1;
        return { _0 : _file, _1 : _f._fixErr(_err) };
    }
    /**
        // fixErr shortens any reported names in PathErrors by stripping f.dir.
    **/
    @:keep
    static public function _fixErr( _f:Ref<T_subFS>, _err:Error):Error {
        {
            var __tmp__ = try {
                { value : (Go.typeAssert((Go.toInterface(_err) : Ref<PathError>)) : Ref<PathError>), ok : true };
            } catch(_) {
                { value : (null : Ref<stdgo.io.fs.Fs.PathError>), ok : false };
            }, _e = __tmp__.value, _ok = __tmp__.ok;
            if (_ok) {
                {
                    var __tmp__ = _f._shorten(_e.path), _short:GoString = __tmp__._0, _ok:Bool = __tmp__._1;
                    if (_ok) {
                        _e.path = _short;
                    };
                };
            };
        };
        return _err;
    }
    /**
        // shorten maps name, which should start with f.dir, back to the suffix after f.dir.
    **/
    @:keep
    static public function _shorten( _f:Ref<T_subFS>, _name:GoString):{ var _0 : GoString; var _1 : Bool; } {
        var _rel:GoString = ("" : GoString), _ok:Bool = false;
        if (_name == (_f._dir)) {
            return { _0 : ("." : GoString), _1 : true };
        };
        if (((_name.length >= (_f._dir.length + (2 : GoInt))) && (_name[(_f._dir.length : GoInt)] == (47 : GoUInt8))) && ((_name.__slice__(0, (_f._dir.length)) : GoString) == _f._dir)) {
            return { _0 : (_name.__slice__((_f._dir.length) + (1 : GoInt)) : GoString), _1 : true };
        };
        return { _0 : Go.str(), _1 : false };
    }
    /**
        // fullName maps name to the fully-qualified name dir/name.
    **/
    @:keep
    static public function _fullName( _f:Ref<T_subFS>, _op:GoString, _name:GoString):{ var _0 : GoString; var _1 : Error; } {
        if (!validPath(_name)) {
            return { _0 : Go.str(), _1 : Go.asInterface((Go.setRef(({ op : _op, path : _name, err : stdgo.errors.Errors.new_(("invalid name" : GoString)) } : PathError)) : Ref<stdgo.io.fs.Fs.PathError>)) };
        };
        return { _0 : stdgo.path.Path.join(_f._dir, _name), _1 : (null : Error) };
    }
}
class T_statDirEntry_asInterface {
    @:keep
    public dynamic function info():{ var _0 : FileInfo; var _1 : Error; } return __self__.value.info();
    @:keep
    public dynamic function type():FileMode return __self__.value.type();
    @:keep
    public dynamic function isDir():Bool return __self__.value.isDir();
    @:keep
    public dynamic function name():GoString return __self__.value.name();
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_statDirEntry>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.io.fs.Fs.T_statDirEntry_asInterface) class T_statDirEntry_static_extension {
    @:keep
    static public function info( _d:Ref<T_statDirEntry>):{ var _0 : FileInfo; var _1 : Error; } {
        return { _0 : _d._info, _1 : (null : Error) };
    }
    @:keep
    static public function type( _d:Ref<T_statDirEntry>):FileMode {
        return _d._info.mode().type();
    }
    @:keep
    static public function isDir( _d:Ref<T_statDirEntry>):Bool {
        return _d._info.isDir();
    }
    @:keep
    static public function name( _d:Ref<T_statDirEntry>):GoString {
        return _d._info.name();
    }
}
class FileMode_asInterface {
    /**
        // Type returns type bits in m (m & ModeType).
    **/
    @:keep
    public dynamic function type():FileMode return __self__.value.type();
    /**
        // Perm returns the Unix permission bits in m (m & ModePerm).
    **/
    @:keep
    public dynamic function perm():FileMode return __self__.value.perm();
    /**
        // IsRegular reports whether m describes a regular file.
        // That is, it tests that no mode type bits are set.
    **/
    @:keep
    public dynamic function isRegular():Bool return __self__.value.isRegular();
    /**
        // IsDir reports whether m describes a directory.
        // That is, it tests for the ModeDir bit being set in m.
    **/
    @:keep
    public dynamic function isDir():Bool return __self__.value.isDir();
    @:keep
    public dynamic function string():GoString return __self__.value.string();
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<FileMode>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.io.fs.Fs.FileMode_asInterface) class FileMode_static_extension {
    /**
        // Type returns type bits in m (m & ModeType).
    **/
    @:keep
    static public function type( _m:FileMode):FileMode {
        return _m & (-1893203968u32 : stdgo.io.fs.Fs.FileMode);
    }
    /**
        // Perm returns the Unix permission bits in m (m & ModePerm).
    **/
    @:keep
    static public function perm( _m:FileMode):FileMode {
        return _m & (511u32 : stdgo.io.fs.Fs.FileMode);
    }
    /**
        // IsRegular reports whether m describes a regular file.
        // That is, it tests that no mode type bits are set.
    **/
    @:keep
    static public function isRegular( _m:FileMode):Bool {
        return _m & (-1893203968u32 : stdgo.io.fs.Fs.FileMode) == ((0u32 : stdgo.io.fs.Fs.FileMode));
    }
    /**
        // IsDir reports whether m describes a directory.
        // That is, it tests for the ModeDir bit being set in m.
    **/
    @:keep
    static public function isDir( _m:FileMode):Bool {
        return _m & (-2147483648u32 : stdgo.io.fs.Fs.FileMode) != ((0u32 : stdgo.io.fs.Fs.FileMode));
    }
    @:keep
    static public function string( _m:FileMode):GoString {
        {};
        var _buf:GoArray<GoByte> = new GoArray<GoUInt8>(...[for (i in 0 ... 32) (0 : GoUInt8)]);
        var _w:GoInt = (0 : GoInt);
        for (_i => _c in ("dalTLDpSugct?" : GoString)) {
            if (_m & ((1u32 : stdgo.io.fs.Fs.FileMode) << ((31 : GoInt) - _i : GoUInt)) != ((0u32 : stdgo.io.fs.Fs.FileMode))) {
                _buf[(_w : GoInt)] = (_c : GoByte);
                _w++;
            };
        };
        if (_w == ((0 : GoInt))) {
            _buf[(_w : GoInt)] = (45 : GoUInt8);
            _w++;
        };
        {};
        for (_i => _c in ("rwxrwxrwx" : GoString)) {
            if (_m & ((1u32 : stdgo.io.fs.Fs.FileMode) << ((8 : GoInt) - _i : GoUInt)) != ((0u32 : stdgo.io.fs.Fs.FileMode))) {
                _buf[(_w : GoInt)] = (_c : GoByte);
            } else {
                _buf[(_w : GoInt)] = (45 : GoUInt8);
            };
            _w++;
        };
        return ((_buf.__slice__(0, _w) : Slice<GoUInt8>) : GoString);
    }
}

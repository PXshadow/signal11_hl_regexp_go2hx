package stdgo.regexp;
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
    // Package regexp implements regular expression search.
    //
    // The syntax of the regular expressions accepted is the same
    // general syntax used by Perl, Python, and other languages.
    // More precisely, it is the syntax accepted by RE2 and described at
    // https://golang.org/s/re2syntax, except for \C.
    // For an overview of the syntax, run
    //
    //	go doc regexp/syntax
    //
    // The regexp implementation provided by this package is
    // guaranteed to run in time linear in the size of the input.
    // (This is a property not guaranteed by most open source
    // implementations of regular expressions.) For more information
    // about this property, see
    //
    //	https://swtch.com/~rsc/regexp/regexp1.html
    //
    // or any book about automata theory.
    //
    // All characters are UTF-8-encoded code points.
    // Following utf8.DecodeRune, each byte of an invalid UTF-8 sequence
    // is treated as if it encoded utf8.RuneError (U+FFFD).
    //
    // There are 16 methods of Regexp that match a regular expression and identify
    // the matched text. Their names are matched by this regular expression:
    //
    //	Find(All)?(String)?(Submatch)?(Index)?
    //
    // If 'All' is present, the routine matches successive non-overlapping
    // matches of the entire expression. Empty matches abutting a preceding
    // match are ignored. The return value is a slice containing the successive
    // return values of the corresponding non-'All' routine. These routines take
    // an extra integer argument, n. If n >= 0, the function returns at most n
    // matches/submatches; otherwise, it returns all of them.
    //
    // If 'String' is present, the argument is a string; otherwise it is a slice
    // of bytes; return values are adjusted as appropriate.
    //
    // If 'Submatch' is present, the return value is a slice identifying the
    // successive submatches of the expression. Submatches are matches of
    // parenthesized subexpressions (also known as capturing groups) within the
    // regular expression, numbered from left to right in order of opening
    // parenthesis. Submatch 0 is the match of the entire expression, submatch 1 is
    // the match of the first parenthesized subexpression, and so on.
    //
    // If 'Index' is present, matches and submatches are identified by byte index
    // pairs within the input string: result[2*n:2*n+2] identifies the indexes of
    // the nth submatch. The pair for n==0 identifies the match of the entire
    // expression. If 'Index' is not present, the match is identified by the text
    // of the match/submatch. If an index is negative or text is nil, it means that
    // subexpression did not match any string in the input. For 'String' versions
    // an empty string means either no match or an empty match.
    //
    // There is also a subset of the methods that can be applied to text read
    // from a RuneReader:
    //
    //	MatchReader, FindReaderIndex, FindReaderSubmatchIndex
    //
    // This set may grow. Note that regular expression matches may need to
    // examine text beyond the text returned by a match, so the methods that
    // match text from a RuneReader may read arbitrarily far into the input
    // before returning.
    //
    // (There are a few other methods that do not match this pattern.)
**/
private var __go2hxdoc__package : Bool;
/**
    
    
    
**/
private var _noRune = (new Slice<GoInt32>(0, 0) : Slice<GoInt32>);
/**
    
    
    
**/
private var _noNext = (new Slice<GoUInt32>(0, 0, (-1u32 : GoUInt32)) : Slice<GoUInt32>);
/**
    
    
    
**/
private var _anyRuneNotNL = (new Slice<GoInt32>(0, 0, (0 : GoInt32), (9 : GoInt32), (11 : GoInt32), (1114111 : GoInt32)) : Slice<GoInt32>);
/**
    
    
    
**/
private var _anyRune = (new Slice<GoInt32>(0, 0, (0 : GoInt32), (1114111 : GoInt32)) : Slice<GoInt32>);
/**
    // Pools of *machine for use during (*Regexp).doExecute,
    // split up by the size of the execution queues.
    // matchPool[i] machines have queue size matchSize[i].
    // On a 64-bit system each queue entry is 16 bytes,
    // so matchPool[0] has 16*2*128 = 4kB queues, etc.
    // The final matchPool is a catch-all for very large queues.
    
    
**/
private var _matchSize = (new GoArray<GoInt>((128 : GoInt), (512 : GoInt), (2048 : GoInt), (16384 : GoInt), (0 : GoInt)) : GoArray<GoInt>);
/**
    
    
    
**/
private final _visitedBits = (32i64 : GoUInt64);
/**
    
    
    // len(prog.Inst) <= max
**/
private final _maxBacktrackProg = (500i64 : GoUInt64);
/**
    
    
    // bit vector size <= max (bits)
**/
private final _maxBacktrackVector = (262144i64 : GoUInt64);
/**
    
    
    
**/
private var _bitStatePool : stdgo.sync.Sync.Pool = ({} : stdgo.sync.Sync.Pool);
/**
    
    
    
**/
private var _onePassPool : stdgo.sync.Sync.Pool = ({} : stdgo.sync.Sync.Pool);
/**
    // arrayNoInts is returned by doExecute match if nil dstCap is passed
    // to it with ncap=0.
    
    
**/
private var _arrayNoInts : GoArray<GoInt> = new GoArray<GoInt>(...[for (i in 0 ... 0) (0 : GoInt)]);
/**
    // mergeRuneSets merges two non-intersecting runesets, and returns the merged result,
    // and a NextIp array. The idea is that if a rune matches the OnePassRunes at index
    // i, NextIp[i/2] is the target. If the input sets intersect, an empty runeset and a
    // NextIp array with the single element mergeFailed is returned.
    // The code assumes that both inputs contain ordered and non-intersecting rune pairs.
    
    
**/
private final _mergeFailed = (-1u32 : GoUInt32);
/**
    // Pools of *machine for use during (*Regexp).doExecute,
    // split up by the size of the execution queues.
    // matchPool[i] machines have queue size matchSize[i].
    // On a 64-bit system each queue entry is 16 bytes,
    // so matchPool[0] has 16*2*128 = 4kB queues, etc.
    // The final matchPool is a catch-all for very large queues.
    
    
**/
private var _matchPool : GoArray<stdgo.sync.Sync.Pool> = new GoArray<stdgo.sync.Sync.Pool>(...[for (i in 0 ... 5) ({} : stdgo.sync.Sync.Pool)]);
/**
    
    
    
**/
private final _endOfText : GoRune = (-1 : GoInt32);
/**
    // Bitmap used by func special to check whether a character needs to be escaped.
    
    
**/
private var _specialBytes : GoArray<GoByte> = new GoArray<GoUInt8>(...[for (i in 0 ... 16) (0 : GoUInt8)]);
/**
    
    
    // The size at which to start a slice in the 'All' routines.
**/
private final _startSize = (10i64 : GoUInt64);
/**
    // input abstracts different representations of the input text. It provides
    // one-character lookahead.
    
    
**/
private typedef T_input = StructType & {
    /**
        
        
        // advance one rune
    **/
    public dynamic function _step(_pos:GoInt):{ var _0 : GoRune; var _1 : GoInt; };
    /**
        
        
        // can we look ahead without losing info?
    **/
    public dynamic function _canCheckPrefix():Bool;
    /**
        
        
        
    **/
    public dynamic function _hasPrefix(_re:Ref<Regexp>):Bool;
    /**
        
        
        
    **/
    public dynamic function _index(_re:Ref<Regexp>, _pos:GoInt):GoInt;
    /**
        
        
        
    **/
    public dynamic function _context(_pos:GoInt):T_lazyFlag;
};
/**
    // A job is an entry on the backtracker's job stack. It holds
    // the instruction pc and the position in the input.
    
    
**/
@:structInit @:private class T_job {
    public var _pc : GoUInt32 = 0;
    public var _arg : Bool = false;
    public var _pos : GoInt = 0;
    public function new(?_pc:GoUInt32, ?_arg:Bool, ?_pos:GoInt) {
        if (_pc != null) this._pc = _pc;
        if (_arg != null) this._arg = _arg;
        if (_pos != null) this._pos = _pos;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_job(_pc, _arg, _pos);
    }
}
/**
    // bitState holds state for the backtracker.
    
    
**/
@:structInit @:private @:using(stdgo.regexp.Regexp.T_bitState_static_extension) class T_bitState {
    public var _end : GoInt = 0;
    public var _cap : Slice<GoInt> = (null : Slice<GoInt>);
    public var _matchcap : Slice<GoInt> = (null : Slice<GoInt>);
    public var _jobs : Slice<stdgo.regexp.Regexp.T_job> = (null : Slice<stdgo.regexp.Regexp.T_job>);
    public var _visited : Slice<GoUInt32> = (null : Slice<GoUInt32>);
    public var _inputs : stdgo.regexp.Regexp.T_inputs = ({} : stdgo.regexp.Regexp.T_inputs);
    public function new(?_end:GoInt, ?_cap:Slice<GoInt>, ?_matchcap:Slice<GoInt>, ?_jobs:Slice<stdgo.regexp.Regexp.T_job>, ?_visited:Slice<GoUInt32>, ?_inputs:stdgo.regexp.Regexp.T_inputs) {
        if (_end != null) this._end = _end;
        if (_cap != null) this._cap = _cap;
        if (_matchcap != null) this._matchcap = _matchcap;
        if (_jobs != null) this._jobs = _jobs;
        if (_visited != null) this._visited = _visited;
        if (_inputs != null) this._inputs = _inputs;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_bitState(_end, _cap, _matchcap, _jobs, _visited, _inputs);
    }
}
/**
    // A queue is a 'sparse array' holding pending threads of execution.
    // See https://research.swtch.com/2008/03/using-uninitialized-memory-for-fun-and.html
    
    
**/
@:structInit @:private class T_queue {
    public var _sparse : Slice<GoUInt32> = (null : Slice<GoUInt32>);
    public var _dense : Slice<stdgo.regexp.Regexp.T_entry> = (null : Slice<stdgo.regexp.Regexp.T_entry>);
    public function new(?_sparse:Slice<GoUInt32>, ?_dense:Slice<stdgo.regexp.Regexp.T_entry>) {
        if (_sparse != null) this._sparse = _sparse;
        if (_dense != null) this._dense = _dense;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_queue(_sparse, _dense);
    }
}
/**
    // An entry is an entry on a queue.
    // It holds both the instruction pc and the actual thread.
    // Some queue entries are just place holders so that the machine
    // knows it has considered that pc. Such entries have t == nil.
    
    
**/
@:structInit @:private class T_entry {
    public var _pc : GoUInt32 = 0;
    public var _t : Ref<stdgo.regexp.Regexp.T_thread> = (null : Ref<stdgo.regexp.Regexp.T_thread>);
    public function new(?_pc:GoUInt32, ?_t:Ref<stdgo.regexp.Regexp.T_thread>) {
        if (_pc != null) this._pc = _pc;
        if (_t != null) this._t = _t;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_entry(_pc, _t);
    }
}
/**
    // A thread is the state of a single path through the machine:
    // an instruction and a corresponding capture array.
    // See https://swtch.com/~rsc/regexp/regexp2.html
    
    
**/
@:structInit @:private class T_thread {
    public var _inst : Ref<stdgo.regexp.syntax.Syntax.Inst> = (null : Ref<stdgo.regexp.syntax.Syntax.Inst>);
    public var _cap : Slice<GoInt> = (null : Slice<GoInt>);
    public function new(?_inst:Ref<stdgo.regexp.syntax.Syntax.Inst>, ?_cap:Slice<GoInt>) {
        if (_inst != null) this._inst = _inst;
        if (_cap != null) this._cap = _cap;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_thread(_inst, _cap);
    }
}
/**
    // A machine holds all the state during an NFA simulation for p.
    
    
**/
@:structInit @:private @:using(stdgo.regexp.Regexp.T_machine_static_extension) class T_machine {
    public var _re : Ref<stdgo.regexp.Regexp.Regexp> = (null : Ref<stdgo.regexp.Regexp.Regexp>);
    public var _p : Ref<stdgo.regexp.syntax.Syntax.Prog> = (null : Ref<stdgo.regexp.syntax.Syntax.Prog>);
    public var _q0 : stdgo.regexp.Regexp.T_queue = ({} : stdgo.regexp.Regexp.T_queue);
    public var _q1 : stdgo.regexp.Regexp.T_queue = ({} : stdgo.regexp.Regexp.T_queue);
    public var _pool : Slice<Ref<stdgo.regexp.Regexp.T_thread>> = (null : Slice<Ref<stdgo.regexp.Regexp.T_thread>>);
    public var _matched : Bool = false;
    public var _matchcap : Slice<GoInt> = (null : Slice<GoInt>);
    public var _inputs : stdgo.regexp.Regexp.T_inputs = ({} : stdgo.regexp.Regexp.T_inputs);
    public function new(?_re:Ref<stdgo.regexp.Regexp.Regexp>, ?_p:Ref<stdgo.regexp.syntax.Syntax.Prog>, ?_q0:stdgo.regexp.Regexp.T_queue, ?_q1:stdgo.regexp.Regexp.T_queue, ?_pool:Slice<Ref<stdgo.regexp.Regexp.T_thread>>, ?_matched:Bool, ?_matchcap:Slice<GoInt>, ?_inputs:stdgo.regexp.Regexp.T_inputs) {
        if (_re != null) this._re = _re;
        if (_p != null) this._p = _p;
        if (_q0 != null) this._q0 = _q0;
        if (_q1 != null) this._q1 = _q1;
        if (_pool != null) this._pool = _pool;
        if (_matched != null) this._matched = _matched;
        if (_matchcap != null) this._matchcap = _matchcap;
        if (_inputs != null) this._inputs = _inputs;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_machine(_re, _p, _q0, _q1, _pool, _matched, _matchcap, _inputs);
    }
}
/**
    
    
    
**/
@:structInit @:private @:using(stdgo.regexp.Regexp.T_inputs_static_extension) class T_inputs {
    /**
        // cached inputs, to avoid allocation
    **/
    public var _bytes : stdgo.regexp.Regexp.T_inputBytes = ({} : stdgo.regexp.Regexp.T_inputBytes);
    public var _string : stdgo.regexp.Regexp.T_inputString = ({} : stdgo.regexp.Regexp.T_inputString);
    public var _reader : stdgo.regexp.Regexp.T_inputReader = ({} : stdgo.regexp.Regexp.T_inputReader);
    public function new(?_bytes:stdgo.regexp.Regexp.T_inputBytes, ?_string:stdgo.regexp.Regexp.T_inputString, ?_reader:stdgo.regexp.Regexp.T_inputReader) {
        if (_bytes != null) this._bytes = _bytes;
        if (_string != null) this._string = _string;
        if (_reader != null) this._reader = _reader;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_inputs(_bytes, _string, _reader);
    }
}
/**
    
    
    
**/
@:structInit @:private class T_onePassMachine {
    public var _inputs : stdgo.regexp.Regexp.T_inputs = ({} : stdgo.regexp.Regexp.T_inputs);
    public var _matchcap : Slice<GoInt> = (null : Slice<GoInt>);
    public function new(?_inputs:stdgo.regexp.Regexp.T_inputs, ?_matchcap:Slice<GoInt>) {
        if (_inputs != null) this._inputs = _inputs;
        if (_matchcap != null) this._matchcap = _matchcap;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_onePassMachine(_inputs, _matchcap);
    }
}
/**
    // A onePassProg is a compiled one-pass regular expression program.
    // It is the same as syntax.Prog except for the use of onePassInst.
    
    
**/
@:structInit @:private class T_onePassProg {
    public var inst : Slice<stdgo.regexp.Regexp.T_onePassInst> = (null : Slice<stdgo.regexp.Regexp.T_onePassInst>);
    public var start : GoInt = 0;
    public var numCap : GoInt = 0;
    public function new(?inst:Slice<stdgo.regexp.Regexp.T_onePassInst>, ?start:GoInt, ?numCap:GoInt) {
        if (inst != null) this.inst = inst;
        if (start != null) this.start = start;
        if (numCap != null) this.numCap = numCap;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_onePassProg(inst, start, numCap);
    }
}
/**
    // A onePassInst is a single instruction in a one-pass regular expression program.
    // It is the same as syntax.Inst except for the new 'Next' field.
    
    
**/
@:structInit @:private @:using(stdgo.regexp.Regexp.T_onePassInst_static_extension) class T_onePassInst {
    @:embedded
    public var inst : stdgo.regexp.syntax.Syntax.Inst = ({} : stdgo.regexp.syntax.Syntax.Inst);
    public var next : Slice<GoUInt32> = (null : Slice<GoUInt32>);
    public function new(?inst:stdgo.regexp.syntax.Syntax.Inst, ?next:Slice<GoUInt32>) {
        if (inst != null) this.inst = inst;
        if (next != null) this.next = next;
    }
    public function __underlying__() return Go.toInterface(this);
    @:embedded
    public function matchEmptyWidth(_before:GoInt32, _after:GoInt32):Bool return inst.matchEmptyWidth(_before, _after);
    @:embedded
    public function matchRune(_r:GoInt32):Bool return inst.matchRune(_r);
    @:embedded
    public function matchRunePos(_r:GoInt32):GoInt return inst.matchRunePos(_r);
    @:embedded
    public function string():GoString return inst.string();
    @:embedded
    public function _op():stdgo.regexp.syntax.Syntax.InstOp return inst._op();
    public function __copy__() {
        return new T_onePassInst(inst, next);
    }
}
/**
    // Sparse Array implementation is used as a queueOnePass.
    
    
**/
@:structInit @:private @:using(stdgo.regexp.Regexp.T_queueOnePass_static_extension) class T_queueOnePass {
    public var _sparse : Slice<GoUInt32> = (null : Slice<GoUInt32>);
    public var _dense : Slice<GoUInt32> = (null : Slice<GoUInt32>);
    public var _size : GoUInt32 = 0;
    public var _nextIndex : GoUInt32 = 0;
    public function new(?_sparse:Slice<GoUInt32>, ?_dense:Slice<GoUInt32>, ?_size:GoUInt32, ?_nextIndex:GoUInt32) {
        if (_sparse != null) this._sparse = _sparse;
        if (_dense != null) this._dense = _dense;
        if (_size != null) this._size = _size;
        if (_nextIndex != null) this._nextIndex = _nextIndex;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_queueOnePass(_sparse, _dense, _size, _nextIndex);
    }
}
/**
    // Regexp is the representation of a compiled regular expression.
    // A Regexp is safe for concurrent use by multiple goroutines,
    // except for configuration methods, such as Longest.
    
    
**/
@:structInit @:using(stdgo.regexp.Regexp.Regexp_static_extension) class Regexp {
    public var _expr : GoString = "";
    public var _prog : Ref<stdgo.regexp.syntax.Syntax.Prog> = (null : Ref<stdgo.regexp.syntax.Syntax.Prog>);
    public var _onepass : Ref<stdgo.regexp.Regexp.T_onePassProg> = (null : Ref<stdgo.regexp.Regexp.T_onePassProg>);
    public var _numSubexp : GoInt = 0;
    public var _maxBitStateLen : GoInt = 0;
    public var _subexpNames : Slice<GoString> = (null : Slice<GoString>);
    public var _prefix : GoString = "";
    public var _prefixBytes : Slice<GoUInt8> = (null : Slice<GoUInt8>);
    public var _prefixRune : GoInt32 = 0;
    public var _prefixEnd : GoUInt32 = 0;
    public var _mpool : GoInt = 0;
    public var _matchcap : GoInt = 0;
    public var _prefixComplete : Bool = false;
    public var _cond : stdgo.regexp.syntax.Syntax.EmptyOp = ((0 : GoUInt8) : stdgo.regexp.syntax.Syntax.EmptyOp);
    public var _minInputLen : GoInt = 0;
    /**
        // This field can be modified by the Longest method,
        // but it is otherwise read-only.
    **/
    public var _longest : Bool = false;
    public function new(?_expr:GoString, ?_prog:Ref<stdgo.regexp.syntax.Syntax.Prog>, ?_onepass:Ref<stdgo.regexp.Regexp.T_onePassProg>, ?_numSubexp:GoInt, ?_maxBitStateLen:GoInt, ?_subexpNames:Slice<GoString>, ?_prefix:GoString, ?_prefixBytes:Slice<GoUInt8>, ?_prefixRune:GoInt32, ?_prefixEnd:GoUInt32, ?_mpool:GoInt, ?_matchcap:GoInt, ?_prefixComplete:Bool, ?_cond:stdgo.regexp.syntax.Syntax.EmptyOp, ?_minInputLen:GoInt, ?_longest:Bool) {
        if (_expr != null) this._expr = _expr;
        if (_prog != null) this._prog = _prog;
        if (_onepass != null) this._onepass = _onepass;
        if (_numSubexp != null) this._numSubexp = _numSubexp;
        if (_maxBitStateLen != null) this._maxBitStateLen = _maxBitStateLen;
        if (_subexpNames != null) this._subexpNames = _subexpNames;
        if (_prefix != null) this._prefix = _prefix;
        if (_prefixBytes != null) this._prefixBytes = _prefixBytes;
        if (_prefixRune != null) this._prefixRune = _prefixRune;
        if (_prefixEnd != null) this._prefixEnd = _prefixEnd;
        if (_mpool != null) this._mpool = _mpool;
        if (_matchcap != null) this._matchcap = _matchcap;
        if (_prefixComplete != null) this._prefixComplete = _prefixComplete;
        if (_cond != null) this._cond = _cond;
        if (_minInputLen != null) this._minInputLen = _minInputLen;
        if (_longest != null) this._longest = _longest;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new Regexp(
_expr,
_prog,
_onepass,
_numSubexp,
_maxBitStateLen,
_subexpNames,
_prefix,
_prefixBytes,
_prefixRune,
_prefixEnd,
_mpool,
_matchcap,
_prefixComplete,
_cond,
_minInputLen,
_longest);
    }
}
/**
    // inputString scans a string.
    
    
**/
@:structInit @:private @:using(stdgo.regexp.Regexp.T_inputString_static_extension) class T_inputString {
    public var _str : GoString = "";
    public function new(?_str:GoString) {
        if (_str != null) this._str = _str;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_inputString(_str);
    }
}
/**
    // inputBytes scans a byte slice.
    
    
**/
@:structInit @:private @:using(stdgo.regexp.Regexp.T_inputBytes_static_extension) class T_inputBytes {
    public var _str : Slice<GoUInt8> = (null : Slice<GoUInt8>);
    public function new(?_str:Slice<GoUInt8>) {
        if (_str != null) this._str = _str;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_inputBytes(_str);
    }
}
/**
    // inputReader scans a RuneReader.
    
    
**/
@:structInit @:private @:using(stdgo.regexp.Regexp.T_inputReader_static_extension) class T_inputReader {
    public var _r : stdgo.io.Io.RuneReader = (null : stdgo.io.Io.RuneReader);
    public var _atEOT : Bool = false;
    public var _pos : GoInt = 0;
    public function new(?_r:stdgo.io.Io.RuneReader, ?_atEOT:Bool, ?_pos:GoInt) {
        if (_r != null) this._r = _r;
        if (_atEOT != null) this._atEOT = _atEOT;
        if (_pos != null) this._pos = _pos;
    }
    public function __underlying__() return Go.toInterface(this);
    public function __copy__() {
        return new T_inputReader(_r, _atEOT, _pos);
    }
}
/**
    // A lazyFlag is a lazily-evaluated syntax.EmptyOp,
    // for checking zero-width flags like ^ $ \A \z \B \b.
    // It records the pair of relevant runes and does not
    // determine the implied flags until absolutely necessary
    // (most of the time, that means never).
**/
@:named @:using(stdgo.regexp.Regexp.T_lazyFlag_static_extension) private typedef T_lazyFlag = GoUInt64;
/**
    // runeSlice exists to permit sorting the case-folded rune sets.
**/
@:named @:using(stdgo.regexp.Regexp.T_runeSlice_static_extension) private typedef T_runeSlice = Slice<GoInt32>;
private function _newBitState():Ref<T_bitState> {
        var __tmp__ = try {
            { value : (Go.typeAssert((_bitStatePool.get() : Ref<T_bitState>)) : Ref<T_bitState>), ok : true };
        } catch(_) {
            { value : (null : Ref<stdgo.regexp.Regexp.T_bitState>), ok : false };
        }, _b = __tmp__.value, _ok = __tmp__.ok;
        if (!_ok) {
            _b = (Go.setRef(({} : stdgo.regexp.Regexp.T_bitState)) : Ref<stdgo.regexp.Regexp.T_bitState>);
        };
        return _b;
    }
private function _freeBitState(_b:Ref<T_bitState>):Void {
        _b._inputs._clear();
        _bitStatePool.put(Go.toInterface(Go.asInterface(_b)));
    }
/**
    // maxBitStateLen returns the maximum length of a string to search with
    // the backtracker using prog.
**/
private function _maxBitStateLen(_prog:Ref<stdgo.regexp.syntax.Syntax.Prog>):GoInt {
        if (!_shouldBacktrack(_prog)) {
            return (0 : GoInt);
        };
        return (262144 : GoInt) / (_prog.inst.length);
    }
/**
    // shouldBacktrack reports whether the program is too
    // long for the backtracker to run.
**/
private function _shouldBacktrack(_prog:Ref<stdgo.regexp.syntax.Syntax.Prog>):Bool {
        return (_prog.inst.length) <= (500 : GoInt);
    }
private function _newLazyFlag(_r1:GoRune, _r2:GoRune):T_lazyFlag {
        return (((_r1 : GoUInt64) << (32i64 : GoUInt64)) | ((_r2 : GoUInt32) : GoUInt64) : T_lazyFlag);
    }
private function _newOnePassMachine():Ref<T_onePassMachine> {
        var __tmp__ = try {
            { value : (Go.typeAssert((_onePassPool.get() : Ref<T_onePassMachine>)) : Ref<T_onePassMachine>), ok : true };
        } catch(_) {
            { value : (null : Ref<stdgo.regexp.Regexp.T_onePassMachine>), ok : false };
        }, _m = __tmp__.value, _ok = __tmp__.ok;
        if (!_ok) {
            _m = (Go.setRef(({} : stdgo.regexp.Regexp.T_onePassMachine)) : Ref<stdgo.regexp.Regexp.T_onePassMachine>);
        };
        return _m;
    }
private function _freeOnePassMachine(_m:Ref<T_onePassMachine>):Void {
        _m._inputs._clear();
        _onePassPool.put(Go.toInterface(_m));
    }
/**
    // onePassPrefix returns a literal string that all matches for the
    // regexp must start with. Complete is true if the prefix
    // is the entire match. Pc is the index of the last rune instruction
    // in the string. The onePassPrefix skips over the mandatory
    // EmptyBeginText.
**/
private function _onePassPrefix(_p:Ref<stdgo.regexp.syntax.Syntax.Prog>):{ var _0 : GoString; var _1 : Bool; var _2 : GoUInt32; } {
        var _prefix:GoString = ("" : GoString), _complete:Bool = false, _pc:GoUInt32 = (0 : GoUInt32);
        var _i = (Go.setRef(_p.inst[(_p.start : GoInt)]) : Ref<stdgo.regexp.syntax.Syntax.Inst>);
        if ((_i.op != (3 : stdgo.regexp.syntax.Syntax.InstOp)) || (((_i.arg : stdgo.regexp.syntax.Syntax.EmptyOp) & (4 : stdgo.regexp.syntax.Syntax.EmptyOp)) == (0 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            return { _0 : Go.str(), _1 : _i.op == ((4 : stdgo.regexp.syntax.Syntax.InstOp)), _2 : (_p.start : GoUInt32) };
        };
        _pc = _i.out;
        _i = (Go.setRef(_p.inst[(_pc : GoInt)]) : Ref<stdgo.regexp.syntax.Syntax.Inst>);
        while (_i.op == ((6 : stdgo.regexp.syntax.Syntax.InstOp))) {
            _pc = _i.out;
            _i = (Go.setRef(_p.inst[(_pc : GoInt)]) : Ref<stdgo.regexp.syntax.Syntax.Inst>);
        };
        if ((_iop(_i) != (7 : stdgo.regexp.syntax.Syntax.InstOp)) || (_i.rune.length != (1 : GoInt))) {
            return { _0 : Go.str(), _1 : _i.op == ((4 : stdgo.regexp.syntax.Syntax.InstOp)), _2 : (_p.start : GoUInt32) };
        };
        var _buf:stdgo.strings.Strings.Builder = ({} : stdgo.strings.Strings.Builder);
        while ((((_iop(_i) == (7 : stdgo.regexp.syntax.Syntax.InstOp)) && (_i.rune.length == (1 : GoInt))) && (((_i.arg : stdgo.regexp.syntax.Syntax.Flags) & (1 : stdgo.regexp.syntax.Syntax.Flags)) == (0 : stdgo.regexp.syntax.Syntax.Flags))) && (_i.rune[(0 : GoInt)] != (65533 : GoInt32))) {
            _buf.writeRune(_i.rune[(0 : GoInt)]);
            {
                final __tmp__0 = _i.out;
                final __tmp__1 = (Go.setRef(_p.inst[(_i.out : GoInt)]) : Ref<stdgo.regexp.syntax.Syntax.Inst>);
                _pc = __tmp__0;
                _i = __tmp__1;
            };
        };
        if (((_i.op == (3 : stdgo.regexp.syntax.Syntax.InstOp)) && (((_i.arg : stdgo.regexp.syntax.Syntax.EmptyOp) & (8 : stdgo.regexp.syntax.Syntax.EmptyOp)) != (0 : stdgo.regexp.syntax.Syntax.EmptyOp))) && (_p.inst[(_i.out : GoInt)].op == (4 : stdgo.regexp.syntax.Syntax.InstOp))) {
            _complete = true;
        };
        return { _0 : (_buf.string() : GoString), _1 : _complete, _2 : _pc };
    }
/**
    // onePassNext selects the next actionable state of the prog, based on the input character.
    // It should only be called when i.Op == InstAlt or InstAltMatch, and from the one-pass machine.
    // One of the alternates may ultimately lead without input to end of line. If the instruction
    // is InstAltMatch the path to the InstMatch is in i.Out, the normal node in i.Next.
**/
private function _onePassNext(_i:Ref<T_onePassInst>, _r:GoRune):GoUInt32 {
        var _next:GoInt = _i.matchRunePos(_r);
        if (_next >= (0 : GoInt)) {
            return _i.next[(_next : GoInt)];
        };
        if (_i.inst.op == ((1 : stdgo.regexp.syntax.Syntax.InstOp))) {
            return _i.inst.out;
        };
        return (0u32 : GoUInt32);
    }
private function _iop(_i:Ref<stdgo.regexp.syntax.Syntax.Inst>):stdgo.regexp.syntax.Syntax.InstOp {
        var _op:stdgo.regexp.syntax.Syntax.InstOp = _i.op;
        {
            final __value__ = _op;
            if (__value__ == ((8 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((9 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((10 : stdgo.regexp.syntax.Syntax.InstOp))) {
                _op = (7 : stdgo.regexp.syntax.Syntax.InstOp);
            };
        };
        return _op;
    }
private function _newQueue(_size:GoInt):Ref<T_queueOnePass> {
        var _q:Ref<T_queueOnePass> = (null : Ref<stdgo.regexp.Regexp.T_queueOnePass>);
        return (Go.setRef(({ _sparse : new Slice<GoUInt32>((_size : GoInt).toBasic(), 0).__setNumber32__(), _dense : new Slice<GoUInt32>((_size : GoInt).toBasic(), 0).__setNumber32__() } : T_queueOnePass)) : Ref<stdgo.regexp.Regexp.T_queueOnePass>);
    }
private function _mergeRuneSets(_leftRunes:Ref<Slice<GoRune>>, _rightRunes:Ref<Slice<GoRune>>, _leftPC:GoUInt32, _rightPC:GoUInt32):{ var _0 : Slice<GoRune>; var _1 : Slice<GoUInt32>; } {
        var __deferstack__:Array<Void -> Void> = [];
        var _leftLen:GoInt = ((_leftRunes : Slice<GoInt32>).length);
        var _rightLen:GoInt = ((_rightRunes : Slice<GoInt32>).length);
        try {
            if (((_leftLen & (1 : GoInt)) != (0 : GoInt)) || ((_rightLen & (1 : GoInt)) != (0 : GoInt))) {
                throw Go.toInterface(("mergeRuneSets odd length []rune" : GoString));
            };
            var __0:GoInt = (0 : GoInt), __1:GoInt = (0 : GoInt), _rx:GoInt = __1, _lx:GoInt = __0;
            var _merged = new Slice<GoInt32>((0 : GoInt).toBasic(), 0).__setNumber32__();
            var _next = new Slice<GoUInt32>((0 : GoInt).toBasic(), 0).__setNumber32__();
            var _ok:Bool = true;
            __deferstack__.unshift(() -> {
                var a = function():Void {
                    if (!_ok) {
                        _merged = (null : Slice<GoInt32>);
                        _next = (null : Slice<GoUInt32>);
                    };
                };
                a();
            });
            var _ix:GoInt = (-1 : GoInt);
            var _extend = function(_newLow:Pointer<GoInt>, _newArray:Ref<Slice<GoRune>>, _pc:GoUInt32):Bool {
                if ((_ix > (0 : GoInt)) && (((_newArray : Slice<GoInt32>))[(_newLow.value : GoInt)] <= _merged[(_ix : GoInt)])) {
                    return false;
                };
                _merged = (_merged.__append__(((_newArray : Slice<GoInt32>))[(_newLow.value : GoInt)], ((_newArray : Slice<GoInt32>))[(_newLow.value + (1 : GoInt) : GoInt)]));
                _newLow.value = _newLow.value + ((2 : GoInt));
                _ix = _ix + ((2 : GoInt));
                _next = (_next.__append__(_pc));
                return true;
            };
            while ((_lx < _leftLen) || (_rx < _rightLen)) {
                if (_rx >= _rightLen) {
                    _ok = _extend(Go.pointer(_lx), _leftRunes, _leftPC);
                } else if (_lx >= _leftLen) {
                    _ok = _extend(Go.pointer(_rx), _rightRunes, _rightPC);
                } else if (((_rightRunes : Slice<GoInt32>))[(_rx : GoInt)] < ((_leftRunes : Slice<GoInt32>))[(_lx : GoInt)]) {
                    _ok = _extend(Go.pointer(_rx), _rightRunes, _rightPC);
                } else {
                    _ok = _extend(Go.pointer(_lx), _leftRunes, _leftPC);
                };
                if (!_ok) {
                    {
                        for (defer in __deferstack__) {
                            defer();
                        };
                        return { _0 : _noRune, _1 : _noNext };
                    };
                };
            };
            {
                for (defer in __deferstack__) {
                    defer();
                };
                return { _0 : _merged, _1 : _next };
            };
            for (defer in __deferstack__) {
                defer();
            };
            {
                for (defer in __deferstack__) {
                    defer();
                };
                if (Go.recover_exception != null) throw Go.recover_exception;
                return { _0 : (null : Slice<GoInt32>), _1 : (null : Slice<GoUInt32>) };
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
            return { _0 : (null : Slice<GoInt32>), _1 : (null : Slice<GoUInt32>) };
        };
    }
/**
    // cleanupOnePass drops working memory, and restores certain shortcut instructions.
**/
private function _cleanupOnePass(_prog:Ref<T_onePassProg>, _original:Ref<stdgo.regexp.syntax.Syntax.Prog>):Void {
        for (_ix => _instOriginal in _original.inst) {
            {
                final __value__ = _instOriginal.op;
                if (__value__ == ((0 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((1 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((7 : stdgo.regexp.syntax.Syntax.InstOp))) {} else if (__value__ == ((2 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((3 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((6 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((4 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((5 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    _prog.inst[(_ix : GoInt)].next = (null : Slice<GoUInt32>);
                } else if (__value__ == ((8 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((9 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((10 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    _prog.inst[(_ix : GoInt)].next = (null : Slice<GoUInt32>);
                    _prog.inst[(_ix : GoInt)] = ({ inst : _instOriginal?.__copy__() } : T_onePassInst);
                };
            };
        };
    }
/**
    // onePassCopy creates a copy of the original Prog, as we'll be modifying it.
**/
private function _onePassCopy(_prog:Ref<stdgo.regexp.syntax.Syntax.Prog>):Ref<T_onePassProg> {
        var _p = (Go.setRef(({ inst : new Slice<stdgo.regexp.Regexp.T_onePassInst>((_prog.inst.length : GoInt).toBasic(), 0), start : _prog.start, numCap : _prog.numCap } : T_onePassProg)) : Ref<stdgo.regexp.Regexp.T_onePassProg>);
        for (_i => inst in _prog.inst) {
            _p.inst[(_i : GoInt)] = ({ inst : inst?.__copy__() } : T_onePassInst);
        };
        for (_pc in 0 ... _p.inst.length.toBasic()) {
            {
                final __value__ = _p.inst[(_pc : GoInt)].inst.op;
                if (__value__ == ((0 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((1 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    var _p_A_Other = Go.pointer(_p.inst[(_pc : GoInt)].inst.out);
                    var _p_A_Alt = Go.pointer(_p.inst[(_pc : GoInt)].inst.arg);
                    var _instAlt:stdgo.regexp.Regexp.T_onePassInst = _p.inst[(_p_A_Alt.value : GoInt)];
                    if (!((_instAlt.inst.op == (0 : stdgo.regexp.syntax.Syntax.InstOp)) || (_instAlt.inst.op == (1 : stdgo.regexp.syntax.Syntax.InstOp)))) {
                        {
                            final __tmp__0 = _p_A_Other;
                            final __tmp__1 = _p_A_Alt;
                            _p_A_Alt = __tmp__0;
                            _p_A_Other = __tmp__1;
                        };
                        _instAlt = _p.inst[(_p_A_Alt.value : GoInt)];
                        if (!((_instAlt.inst.op == (0 : stdgo.regexp.syntax.Syntax.InstOp)) || (_instAlt.inst.op == (1 : stdgo.regexp.syntax.Syntax.InstOp)))) {
                            continue;
                        };
                    };
                    var _instOther:stdgo.regexp.Regexp.T_onePassInst = _p.inst[(_p_A_Other.value : GoInt)];
                    if ((_instOther.inst.op == (0 : stdgo.regexp.syntax.Syntax.InstOp)) || (_instOther.inst.op == (1 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        continue;
                    };
                    var _p_B_Alt = Go.pointer(_p.inst[(_p_A_Alt.value : GoInt)].inst.out);
                    var _p_B_Other = Go.pointer(_p.inst[(_p_A_Alt.value : GoInt)].inst.arg);
                    var _patch:Bool = false;
                    if (_instAlt.inst.out == ((_pc : GoUInt32))) {
                        _patch = true;
                    } else if (_instAlt.inst.arg == ((_pc : GoUInt32))) {
                        _patch = true;
                        {
                            final __tmp__0 = _p_B_Other;
                            final __tmp__1 = _p_B_Alt;
                            _p_B_Alt = __tmp__0;
                            _p_B_Other = __tmp__1;
                        };
                    };
                    if (_patch) {
                        _p_B_Alt.value = _p_A_Other.value;
                    };
                    if (_p_A_Other.value == (_p_B_Alt.value)) {
                        _p_A_Alt.value = _p_B_Other.value;
                    };
                } else {
                    continue;
                };
            };
        };
        return _p;
    }
/**
    // makeOnePass creates a onepass Prog, if possible. It is possible if at any alt,
    // the match engine can always tell which branch to take. The routine may modify
    // p if it is turned into a onepass Prog. If it isn't possible for this to be a
    // onepass Prog, the Prog nil is returned. makeOnePass is recursive
    // to the size of the Prog.
**/
private function _makeOnePass(_p:Ref<T_onePassProg>):Ref<T_onePassProg> {
        if ((_p.inst.length) >= (1000 : GoInt)) {
            return null;
        };
        var __0:Ref<stdgo.regexp.Regexp.T_queueOnePass> = _newQueue((_p.inst.length)), __1:Ref<stdgo.regexp.Regexp.T_queueOnePass> = _newQueue((_p.inst.length)), __2:(GoUInt32, Slice<Bool>) -> Bool = null, __3:Slice<Slice<GoInt32>> = new Slice<Slice<GoInt32>>((_p.inst.length : GoInt).toBasic(), 0), _onePassRunes:Slice<Slice<GoInt32>> = __3, _check:(GoUInt32, Slice<Bool>) -> Bool = __2, _visitQueue:Ref<stdgo.regexp.Regexp.T_queueOnePass> = __1, _instQueue:Ref<stdgo.regexp.Regexp.T_queueOnePass> = __0;
        _check = function(_pc:GoUInt32, _m:Slice<Bool>):Bool {
            var _ok:Bool = false;
            _ok = true;
            var _inst = (Go.setRef(_p.inst[(_pc : GoInt)]) : Ref<stdgo.regexp.Regexp.T_onePassInst>);
            if (_visitQueue._contains(_pc)) {
                return _ok;
            };
            _visitQueue._insert(_pc);
            {
                var __switchIndex__ = -1;
                var __run__ = true;
                while (__run__) {
                    __run__ = false;
                    {
                        final __value__ = _inst.inst.op;
                        if (__value__ == ((0 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((1 : stdgo.regexp.syntax.Syntax.InstOp))) {
                            _ok = _check(_inst.inst.out, _m) && _check(_inst.inst.arg, _m);
                            var _matchOut:Bool = _m[(_inst.inst.out : GoInt)];
                            var _matchArg:Bool = _m[(_inst.inst.arg : GoInt)];
                            if (_matchOut && _matchArg) {
                                _ok = false;
                                break;
                            };
                            if (_matchArg) {
                                {
                                    final __tmp__0 = _inst.inst.arg;
                                    final __tmp__1 = _inst.inst.out;
                                    _inst.inst.out = __tmp__0;
                                    _inst.inst.arg = __tmp__1;
                                };
                                {
                                    final __tmp__0 = _matchArg;
                                    final __tmp__1 = _matchOut;
                                    _matchOut = __tmp__0;
                                    _matchArg = __tmp__1;
                                };
                            };
                            if (_matchOut) {
                                _m[(_pc : GoInt)] = true;
                                _inst.inst.op = (1 : stdgo.regexp.syntax.Syntax.InstOp);
                            };
                            {
                                var __tmp__ = _mergeRuneSets((Go.setRef(_onePassRunes[(_inst.inst.out : GoInt)]) : Ref<Slice<GoInt32>>), (Go.setRef(_onePassRunes[(_inst.inst.arg : GoInt)]) : Ref<Slice<GoInt32>>), _inst.inst.out, _inst.inst.arg);
                                _onePassRunes[(_pc : GoInt)] = __tmp__._0;
                                _inst.next = __tmp__._1;
                            };
                            if ((_inst.next.length > (0 : GoInt)) && (_inst.next[(0 : GoInt)] == (-1u32 : GoUInt32))) {
                                _ok = false;
                                break;
                            };
                            break;
                        } else if (__value__ == ((2 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((6 : stdgo.regexp.syntax.Syntax.InstOp))) {
                            _ok = _check(_inst.inst.out, _m);
                            _m[(_pc : GoInt)] = _m[(_inst.inst.out : GoInt)];
                            _onePassRunes[(_pc : GoInt)] = ((new Slice<GoInt32>(0, 0) : Slice<GoInt32>).__append__(..._onePassRunes[(_inst.inst.out : GoInt)].__toArray__()));
                            _inst.next = new Slice<GoUInt32>(((_onePassRunes[(_pc : GoInt)].length / (2 : GoInt)) + (1 : GoInt) : GoInt).toBasic(), 0).__setNumber32__();
                            for (_i in 0 ... _inst.next.length.toBasic()) {
                                _inst.next[(_i : GoInt)] = _inst.inst.out;
                            };
                            break;
                        } else if (__value__ == ((3 : stdgo.regexp.syntax.Syntax.InstOp))) {
                            _ok = _check(_inst.inst.out, _m);
                            _m[(_pc : GoInt)] = _m[(_inst.inst.out : GoInt)];
                            _onePassRunes[(_pc : GoInt)] = ((new Slice<GoInt32>(0, 0) : Slice<GoInt32>).__append__(..._onePassRunes[(_inst.inst.out : GoInt)].__toArray__()));
                            _inst.next = new Slice<GoUInt32>(((_onePassRunes[(_pc : GoInt)].length / (2 : GoInt)) + (1 : GoInt) : GoInt).toBasic(), 0).__setNumber32__();
                            for (_i in 0 ... _inst.next.length.toBasic()) {
                                _inst.next[(_i : GoInt)] = _inst.inst.out;
                            };
                            break;
                        } else if (__value__ == ((4 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((5 : stdgo.regexp.syntax.Syntax.InstOp))) {
                            _m[(_pc : GoInt)] = _inst.inst.op == ((4 : stdgo.regexp.syntax.Syntax.InstOp));
                            break;
                        } else if (__value__ == ((7 : stdgo.regexp.syntax.Syntax.InstOp))) {
                            _m[(_pc : GoInt)] = false;
                            if ((_inst.next.length) > (0 : GoInt)) {
                                break;
                            };
                            _instQueue._insert(_inst.inst.out);
                            if ((_inst.inst.rune.length) == ((0 : GoInt))) {
                                _onePassRunes[(_pc : GoInt)] = (new Slice<GoInt32>(0, 0) : Slice<GoInt32>);
                                _inst.next = (new Slice<GoUInt32>(0, 0, _inst.inst.out) : Slice<GoUInt32>);
                                break;
                            };
                            var _runes = new Slice<GoInt32>((0 : GoInt).toBasic(), 0).__setNumber32__();
                            if ((_inst.inst.rune.length == (1 : GoInt)) && (((_inst.inst.arg : stdgo.regexp.syntax.Syntax.Flags) & (1 : stdgo.regexp.syntax.Syntax.Flags)) != (0 : stdgo.regexp.syntax.Syntax.Flags))) {
                                var _r0:GoInt32 = _inst.inst.rune[(0 : GoInt)];
                                _runes = (_runes.__append__(_r0, _r0));
                                {
                                    var _r1:GoInt32 = stdgo.unicode.Unicode.simpleFold(_r0);
                                    Go.cfor(_r1 != (_r0), _r1 = stdgo.unicode.Unicode.simpleFold(_r1), {
                                        _runes = (_runes.__append__(_r1, _r1));
                                    });
                                };
                                stdgo.sort.Sort.sort(Go.asInterface((_runes : T_runeSlice)));
                            } else {
                                _runes = (_runes.__append__(..._inst.inst.rune.__toArray__()));
                            };
                            _onePassRunes[(_pc : GoInt)] = _runes;
                            _inst.next = new Slice<GoUInt32>(((_onePassRunes[(_pc : GoInt)].length / (2 : GoInt)) + (1 : GoInt) : GoInt).toBasic(), 0).__setNumber32__();
                            for (_i in 0 ... _inst.next.length.toBasic()) {
                                _inst.next[(_i : GoInt)] = _inst.inst.out;
                            };
                            _inst.inst.op = (7 : stdgo.regexp.syntax.Syntax.InstOp);
                            break;
                        } else if (__value__ == ((8 : stdgo.regexp.syntax.Syntax.InstOp))) {
                            _m[(_pc : GoInt)] = false;
                            if ((_inst.next.length) > (0 : GoInt)) {
                                break;
                            };
                            _instQueue._insert(_inst.inst.out);
                            var _runes = (new Slice<GoInt32>(0, 0) : Slice<GoInt32>);
                            if ((_inst.inst.arg : stdgo.regexp.syntax.Syntax.Flags) & (1 : stdgo.regexp.syntax.Syntax.Flags) != ((0 : stdgo.regexp.syntax.Syntax.Flags))) {
                                var _r0:GoInt32 = _inst.inst.rune[(0 : GoInt)];
                                _runes = (_runes.__append__(_r0, _r0));
                                {
                                    var _r1:GoInt32 = stdgo.unicode.Unicode.simpleFold(_r0);
                                    Go.cfor(_r1 != (_r0), _r1 = stdgo.unicode.Unicode.simpleFold(_r1), {
                                        _runes = (_runes.__append__(_r1, _r1));
                                    });
                                };
                                stdgo.sort.Sort.sort(Go.asInterface((_runes : T_runeSlice)));
                            } else {
                                _runes = (_runes.__append__(_inst.inst.rune[(0 : GoInt)], _inst.inst.rune[(0 : GoInt)]));
                            };
                            _onePassRunes[(_pc : GoInt)] = _runes;
                            _inst.next = new Slice<GoUInt32>(((_onePassRunes[(_pc : GoInt)].length / (2 : GoInt)) + (1 : GoInt) : GoInt).toBasic(), 0).__setNumber32__();
                            for (_i in 0 ... _inst.next.length.toBasic()) {
                                _inst.next[(_i : GoInt)] = _inst.inst.out;
                            };
                            _inst.inst.op = (7 : stdgo.regexp.syntax.Syntax.InstOp);
                            break;
                        } else if (__value__ == ((9 : stdgo.regexp.syntax.Syntax.InstOp))) {
                            _m[(_pc : GoInt)] = false;
                            if ((_inst.next.length) > (0 : GoInt)) {
                                break;
                            };
                            _instQueue._insert(_inst.inst.out);
                            _onePassRunes[(_pc : GoInt)] = ((new Slice<GoInt32>(0, 0) : Slice<GoInt32>).__append__(..._anyRune.__toArray__()));
                            _inst.next = (new Slice<GoUInt32>(0, 0, _inst.inst.out) : Slice<GoUInt32>);
                            break;
                        } else if (__value__ == ((10 : stdgo.regexp.syntax.Syntax.InstOp))) {
                            _m[(_pc : GoInt)] = false;
                            if ((_inst.next.length) > (0 : GoInt)) {
                                break;
                            };
                            _instQueue._insert(_inst.inst.out);
                            _onePassRunes[(_pc : GoInt)] = ((new Slice<GoInt32>(0, 0) : Slice<GoInt32>).__append__(..._anyRuneNotNL.__toArray__()));
                            _inst.next = new Slice<GoUInt32>(((_onePassRunes[(_pc : GoInt)].length / (2 : GoInt)) + (1 : GoInt) : GoInt).toBasic(), 0).__setNumber32__();
                            for (_i in 0 ... _inst.next.length.toBasic()) {
                                _inst.next[(_i : GoInt)] = _inst.inst.out;
                            };
                            break;
                        };
                    };
                    break;
                };
            };
            return _ok;
        };
        _instQueue._clear();
        _instQueue._insert((_p.start : GoUInt32));
        var _m = new Slice<Bool>((_p.inst.length : GoInt).toBasic(), 0);
        while (!_instQueue._empty()) {
            _visitQueue._clear();
            var _pc:GoUInt32 = _instQueue._next();
            if (!_check(_pc, _m)) {
                _p = null;
                break;
            };
        };
        if (_p != null && ((_p : Dynamic).__nil__ == null || !(_p : Dynamic).__nil__)) {
            for (_i in 0 ... _p.inst.length.toBasic()) {
                _p.inst[(_i : GoInt)].inst.rune = _onePassRunes[(_i : GoInt)];
            };
        };
        return _p;
    }
/**
    // compileOnePass returns a new *syntax.Prog suitable for onePass execution if the original Prog
    // can be recharacterized as a one-pass regexp program, or syntax.nil if the
    // Prog cannot be converted. For a one pass prog, the fundamental condition that must
    // be true is: at any InstAlt, there must be no ambiguity about what branch to  take.
**/
private function _compileOnePass(_prog:Ref<stdgo.regexp.syntax.Syntax.Prog>):Ref<T_onePassProg> {
        var _p:Ref<T_onePassProg> = (null : Ref<stdgo.regexp.Regexp.T_onePassProg>);
        if (_prog.start == ((0 : GoInt))) {
            return null;
        };
        if ((_prog.inst[(_prog.start : GoInt)].op != (3 : stdgo.regexp.syntax.Syntax.InstOp)) || (((_prog.inst[(_prog.start : GoInt)].arg : stdgo.regexp.syntax.Syntax.EmptyOp) & (4 : stdgo.regexp.syntax.Syntax.EmptyOp)) != (4 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            return null;
        };
        for (__0 => inst in _prog.inst) {
            var _opOut:stdgo.regexp.syntax.Syntax.InstOp = _prog.inst[(inst.out : GoInt)].op;
            {
                final __value__ = inst.op;
                if (__value__ == ((0 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((1 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    if ((_opOut == (4 : stdgo.regexp.syntax.Syntax.InstOp)) || (_prog.inst[(inst.arg : GoInt)].op == (4 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        return null;
                    };
                } else if (__value__ == ((3 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    if (_opOut == ((4 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if ((inst.arg : stdgo.regexp.syntax.Syntax.EmptyOp) & (8 : stdgo.regexp.syntax.Syntax.EmptyOp) == ((8 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
                            continue;
                        };
                        return null;
                    };
                } else {
                    if (_opOut == ((4 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        return null;
                    };
                };
            };
        };
        _p = _onePassCopy(_prog);
        _p = _makeOnePass(_p);
        if (_p != null && ((_p : Dynamic).__nil__ == null || !(_p : Dynamic).__nil__)) {
            _cleanupOnePass(_p, _prog);
        };
        return _p;
    }
/**
    // Compile parses a regular expression and returns, if successful,
    // a Regexp object that can be used to match against text.
    //
    // When matching against text, the regexp returns a match that
    // begins as early as possible in the input (leftmost), and among those
    // it chooses the one that a backtracking search would have found first.
    // This so-called leftmost-first matching is the same semantics
    // that Perl, Python, and other implementations use, although this
    // package implements it without the expense of backtracking.
    // For POSIX leftmost-longest matching, see CompilePOSIX.
**/
function compile(_expr:GoString):{ var _0 : Ref<Regexp>; var _1 : Error; } {
        return _compile(_expr, (212 : stdgo.regexp.syntax.Syntax.Flags), false);
    }
/**
    // CompilePOSIX is like Compile but restricts the regular expression
    // to POSIX ERE (egrep) syntax and changes the match semantics to
    // leftmost-longest.
    //
    // That is, when matching against text, the regexp returns a match that
    // begins as early as possible in the input (leftmost), and among those
    // it chooses a match that is as long as possible.
    // This so-called leftmost-longest matching is the same semantics
    // that early regular expression implementations used and that POSIX
    // specifies.
    //
    // However, there can be multiple leftmost-longest matches, with different
    // submatch choices, and here this package diverges from POSIX.
    // Among the possible leftmost-longest matches, this package chooses
    // the one that a backtracking search would have found first, while POSIX
    // specifies that the match be chosen to maximize the length of the first
    // subexpression, then the second, and so on from left to right.
    // The POSIX rule is computationally prohibitive and not even well-defined.
    // See https://swtch.com/~rsc/regexp/regexp2.html#posix for details.
**/
function compilePOSIX(_expr:GoString):{ var _0 : Ref<Regexp>; var _1 : Error; } {
        return _compile(_expr, (0 : stdgo.regexp.syntax.Syntax.Flags), true);
    }
private function _compile(_expr:GoString, _mode:stdgo.regexp.syntax.Syntax.Flags, _longest:Bool):{ var _0 : Ref<Regexp>; var _1 : Error; } {
        var __tmp__ = stdgo.regexp.syntax.Syntax.parse(_expr, _mode), _re:Ref<stdgo.regexp.syntax.Syntax.Regexp> = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : null, _1 : _err };
        };
        var _maxCap:GoInt = _re.maxCap();
        var _capNames = _re.capNames();
        _re = _re.simplify();
        var __tmp__ = stdgo.regexp.syntax.Syntax.compile(_re), _prog:Ref<stdgo.regexp.syntax.Syntax.Prog> = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : null, _1 : _err };
        };
        var _matchcap:GoInt = _prog.numCap;
        if (_matchcap < (2 : GoInt)) {
            _matchcap = (2 : GoInt);
        };
        var _regexp = (Go.setRef(({ _expr : _expr, _prog : _prog, _onepass : _compileOnePass(_prog), _numSubexp : _maxCap, _subexpNames : _capNames, _matchcap : _matchcap, _cond : _prog.startCond(), _minInputLen : _minInputLen(_re), _longest : _longest } : Regexp)) : Ref<stdgo.regexp.Regexp.Regexp>);
        if (_regexp._onepass == null || (_regexp._onepass : Dynamic).__nil__) {
            {
                var __tmp__ = _prog.prefix();
                _regexp._prefix = __tmp__._0;
                _regexp._prefixComplete = __tmp__._1;
            };
            _regexp._maxBitStateLen = _maxBitStateLen(_prog);
        } else {
            {
                var __tmp__ = _onePassPrefix(_prog);
                _regexp._prefix = __tmp__._0;
                _regexp._prefixComplete = __tmp__._1;
                _regexp._prefixEnd = __tmp__._2;
            };
        };
        if (_regexp._prefix != (Go.str())) {
            _regexp._prefixBytes = (_regexp._prefix : Slice<GoByte>);
            {
                var __tmp__ = stdgo.unicode.utf8.Utf8.decodeRuneInString(_regexp._prefix);
                _regexp._prefixRune = __tmp__._0;
            };
        };
        var _n:GoInt = (_prog.inst.length);
        var _i:GoInt = (0 : GoInt);
        while ((_matchSize[(_i : GoInt)] != (0 : GoInt)) && (_matchSize[(_i : GoInt)] < _n)) {
            _i++;
        };
        _regexp._mpool = _i;
        return { _0 : _regexp, _1 : (null : Error) };
    }
/**
    // minInputLen walks the regexp to find the minimum length of any matchable input.
**/
private function _minInputLen(_re:Ref<stdgo.regexp.syntax.Syntax.Regexp>):GoInt {
        {
            final __value__ = _re.op;
            if (__value__ == ((6 : stdgo.regexp.syntax.Syntax.Op)) || __value__ == ((5 : stdgo.regexp.syntax.Syntax.Op)) || __value__ == ((4 : stdgo.regexp.syntax.Syntax.Op))) {
                return (1 : GoInt);
            } else if (__value__ == ((3 : stdgo.regexp.syntax.Syntax.Op))) {
                var _l:GoInt = (0 : GoInt);
                for (__0 => _r in _re.rune) {
                    if (_r == ((65533 : GoInt32))) {
                        _l++;
                    } else {
                        _l = _l + (stdgo.unicode.utf8.Utf8.runeLen(_r));
                    };
                };
                return _l;
            } else if (__value__ == ((13 : stdgo.regexp.syntax.Syntax.Op)) || __value__ == ((15 : stdgo.regexp.syntax.Syntax.Op))) {
                return _minInputLen(_re.sub[(0 : GoInt)]);
            } else if (__value__ == ((17 : stdgo.regexp.syntax.Syntax.Op))) {
                return _re.min * _minInputLen(_re.sub[(0 : GoInt)]);
            } else if (__value__ == ((18 : stdgo.regexp.syntax.Syntax.Op))) {
                var _l:GoInt = (0 : GoInt);
                for (__1 => _sub in _re.sub) {
                    _l = _l + (_minInputLen(_sub));
                };
                return _l;
            } else if (__value__ == ((19 : stdgo.regexp.syntax.Syntax.Op))) {
                var _l:GoInt = _minInputLen(_re.sub[(0 : GoInt)]);
                var _lnext:GoInt = (0 : GoInt);
                for (__2 => _sub in (_re.sub.__slice__((1 : GoInt)) : Slice<Ref<stdgo.regexp.syntax.Syntax.Regexp>>)) {
                    _lnext = _minInputLen(_sub);
                    if (_lnext < _l) {
                        _l = _lnext;
                    };
                };
                return _l;
            } else {
                return (0 : GoInt);
            };
        };
    }
/**
    // MustCompile is like Compile but panics if the expression cannot be parsed.
    // It simplifies safe initialization of global variables holding compiled regular
    // expressions.
**/
function mustCompile(_str:GoString):Ref<Regexp> {
        var __tmp__ = compile(_str), _regexp:Ref<stdgo.regexp.Regexp.Regexp> = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            throw Go.toInterface(((("regexp: Compile(" : GoString) + _quote(_str)) + ("): " : GoString)) + _err.error());
        };
        return _regexp;
    }
/**
    // MustCompilePOSIX is like CompilePOSIX but panics if the expression cannot be parsed.
    // It simplifies safe initialization of global variables holding compiled regular
    // expressions.
**/
function mustCompilePOSIX(_str:GoString):Ref<Regexp> {
        var __tmp__ = compilePOSIX(_str), _regexp:Ref<stdgo.regexp.Regexp.Regexp> = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            throw Go.toInterface(((("regexp: CompilePOSIX(" : GoString) + _quote(_str)) + ("): " : GoString)) + _err.error());
        };
        return _regexp;
    }
private function _quote(_s:GoString):GoString {
        if (stdgo.strconv.Strconv.canBackquote(_s)) {
            return (("`" : GoString) + _s) + ("`" : GoString);
        };
        return stdgo.strconv.Strconv.quote(_s);
    }
/**
    // MatchReader reports whether the text returned by the RuneReader
    // contains any match of the regular expression pattern.
    // More complicated queries need to use Compile and the full Regexp interface.
**/
function matchReader(_pattern:GoString, _r:stdgo.io.Io.RuneReader):{ var _0 : Bool; var _1 : Error; } {
        var _matched:Bool = false, _err:Error = (null : Error);
        var __tmp__ = compile(_pattern), _re:Ref<stdgo.regexp.Regexp.Regexp> = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : false, _1 : _err };
        };
        return { _0 : _re.matchReader(_r), _1 : (null : Error) };
    }
/**
    // MatchString reports whether the string s
    // contains any match of the regular expression pattern.
    // More complicated queries need to use Compile and the full Regexp interface.
**/
function matchString(_pattern:GoString, _s:GoString):{ var _0 : Bool; var _1 : Error; } {
        var _matched:Bool = false, _err:Error = (null : Error);
        var __tmp__ = compile(_pattern), _re:Ref<stdgo.regexp.Regexp.Regexp> = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : false, _1 : _err };
        };
        return { _0 : _re.matchString(_s), _1 : (null : Error) };
    }
/**
    // Match reports whether the byte slice b
    // contains any match of the regular expression pattern.
    // More complicated queries need to use Compile and the full Regexp interface.
**/
function match(_pattern:GoString, _b:Slice<GoByte>):{ var _0 : Bool; var _1 : Error; } {
        var _matched:Bool = false, _err:Error = (null : Error);
        var __tmp__ = compile(_pattern), _re:Ref<stdgo.regexp.Regexp.Regexp> = __tmp__._0, _err:Error = __tmp__._1;
        if (_err != null) {
            return { _0 : false, _1 : _err };
        };
        return { _0 : _re.match(_b), _1 : (null : Error) };
    }
/**
    // special reports whether byte b needs to be escaped by QuoteMeta.
**/
private function _special(_b:GoByte):Bool {
        return (_b < (128 : GoUInt8)) && ((_specialBytes[(_b % (16 : GoUInt8) : GoInt)] & ((1 : GoUInt8) << (_b / (16 : GoUInt8)))) != (0 : GoUInt8));
    }
/**
    // QuoteMeta returns a string that escapes all regular expression metacharacters
    // inside the argument text; the returned string is a regular expression matching
    // the literal text.
**/
function quoteMeta(_s:GoString):GoString {
        var _i:GoInt = (0 : GoInt);
        {
            _i = (0 : GoInt);
            Go.cfor(_i < (_s.length), _i++, {
                if (_special(_s[(_i : GoInt)])) {
                    break;
                };
            });
        };
        if (_i >= (_s.length)) {
            return _s;
        };
        var _b = new Slice<GoUInt8>((((2 : GoInt) * _s.length) - _i : GoInt).toBasic(), 0).__setNumber32__();
        Go.copySlice(_b, (_s.__slice__(0, _i) : GoString));
        var _j:GoInt = _i;
        Go.cfor(_i < (_s.length), _i++, {
            if (_special(_s[(_i : GoInt)])) {
                _b[(_j : GoInt)] = (92 : GoUInt8);
                _j++;
            };
            _b[(_j : GoInt)] = _s[(_i : GoInt)];
            _j++;
        });
        return ((_b.__slice__(0, _j) : Slice<GoUInt8>) : GoString);
    }
/**
    // extract returns the name from a leading "name" or "{name}" in str.
    // (The $ has already been removed by the caller.)
    // If it is a number, extract returns num set to that number; otherwise num = -1.
**/
private function _extract(_str:GoString):{ var _0 : GoString; var _1 : GoInt; var _2 : GoString; var _3 : Bool; } {
        var _name:GoString = ("" : GoString), _num:GoInt = (0 : GoInt), _rest:GoString = ("" : GoString), _ok:Bool = false;
        if (_str == (Go.str())) {
            return { _0 : _name, _1 : _num, _2 : _rest, _3 : _ok };
        };
        var _brace:Bool = false;
        if (_str[(0 : GoInt)] == ((123 : GoUInt8))) {
            _brace = true;
            _str = (_str.__slice__((1 : GoInt)) : GoString);
        };
        var _i:GoInt = (0 : GoInt);
        while (_i < (_str.length)) {
            var __tmp__ = stdgo.unicode.utf8.Utf8.decodeRuneInString((_str.__slice__(_i) : GoString)), _rune:GoInt32 = __tmp__._0, _size:GoInt = __tmp__._1;
            if ((!stdgo.unicode.Unicode.isLetter(_rune) && !stdgo.unicode.Unicode.isDigit(_rune)) && (_rune != (95 : GoInt32))) {
                break;
            };
            _i = _i + (_size);
        };
        if (_i == ((0 : GoInt))) {
            return { _0 : _name, _1 : _num, _2 : _rest, _3 : _ok };
        };
        _name = (_str.__slice__(0, _i) : GoString);
        if (_brace) {
            if ((_i >= _str.length) || (_str[(_i : GoInt)] != (125 : GoUInt8))) {
                return { _0 : _name, _1 : _num, _2 : _rest, _3 : _ok };
            };
            _i++;
        };
        _num = (0 : GoInt);
        {
            var _i:GoInt = (0 : GoInt);
            Go.cfor(_i < (_name.length), _i++, {
                if (((_name[(_i : GoInt)] < (48 : GoUInt8)) || ((57 : GoUInt8) < _name[(_i : GoInt)])) || (_num >= (100000000 : GoInt))) {
                    _num = (-1 : GoInt);
                    break;
                };
                _num = ((_num * (10 : GoInt)) + (_name[(_i : GoInt)] : GoInt)) - (48 : GoInt);
            });
        };
        if ((_name[(0 : GoInt)] == (48 : GoUInt8)) && (_name.length > (1 : GoInt))) {
            _num = (-1 : GoInt);
        };
        _rest = (_str.__slice__(_i) : GoString);
        _ok = true;
        return { _0 : _name, _1 : _num, _2 : _rest, _3 : _ok };
    }
@:keep var _ = {
        try {
            for (__0 => _b in (("\\.+*?()|[]{}^$$" : GoString) : Slice<GoByte>)) {
                _specialBytes[(_b % (16 : GoUInt8) : GoInt)] = _specialBytes[(_b % (16 : GoUInt8) : GoInt)] | ((1 : GoUInt8) << (_b / (16 : GoUInt8)));
            };
        } catch(__exception__) if (__exception__.message != "__return__") throw __exception__;
        true;
    };
class T_bitState_asInterface {
    /**
        // push pushes (pc, pos, arg) onto the job stack if it should be
        // visited.
    **/
    @:keep
    public dynamic function _push(_re:Ref<Regexp>, _pc:GoUInt32, _pos:GoInt, _arg:Bool):Void __self__.value._push(_re, _pc, _pos, _arg);
    /**
        // shouldVisit reports whether the combination of (pc, pos) has not
        // been visited yet.
    **/
    @:keep
    public dynamic function _shouldVisit(_pc:GoUInt32, _pos:GoInt):Bool return __self__.value._shouldVisit(_pc, _pos);
    /**
        // reset resets the state of the backtracker.
        // end is the end position in the input.
        // ncap is the number of captures.
    **/
    @:keep
    public dynamic function _reset(_prog:Ref<stdgo.regexp.syntax.Syntax.Prog>, _end:GoInt, _ncap:GoInt):Void __self__.value._reset(_prog, _end, _ncap);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_bitState>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_bitState_asInterface) class T_bitState_static_extension {
    /**
        // push pushes (pc, pos, arg) onto the job stack if it should be
        // visited.
    **/
    @:keep
    static public function _push( _b:Ref<T_bitState>, _re:Ref<Regexp>, _pc:GoUInt32, _pos:GoInt, _arg:Bool):Void {
        if ((_re._prog.inst[(_pc : GoInt)].op != (5 : stdgo.regexp.syntax.Syntax.InstOp)) && (_arg || _b._shouldVisit(_pc, _pos))) {
            _b._jobs = (_b._jobs.__append__(({ _pc : _pc, _arg : _arg, _pos : _pos } : T_job)));
        };
    }
    /**
        // shouldVisit reports whether the combination of (pc, pos) has not
        // been visited yet.
    **/
    @:keep
    static public function _shouldVisit( _b:Ref<T_bitState>, _pc:GoUInt32, _pos:GoInt):Bool {
        var _n:GoUInt = (((_pc : GoInt) * (_b._end + (1 : GoInt))) + _pos : GoUInt);
        if (_b._visited[(_n / (32u32 : GoUInt) : GoInt)] & ((1u32 : GoUInt32) << (_n & (31u32 : GoUInt))) != ((0u32 : GoUInt32))) {
            return false;
        };
        _b._visited[(_n / (32u32 : GoUInt) : GoInt)] = _b._visited[(_n / (32u32 : GoUInt) : GoInt)] | ((1u32 : GoUInt32) << (_n & (31u32 : GoUInt)));
        return true;
    }
    /**
        // reset resets the state of the backtracker.
        // end is the end position in the input.
        // ncap is the number of captures.
    **/
    @:keep
    static public function _reset( _b:Ref<T_bitState>, _prog:Ref<stdgo.regexp.syntax.Syntax.Prog>, _end:GoInt, _ncap:GoInt):Void {
        _b._end = _end;
        if (_b._jobs.capacity == ((0 : GoInt))) {
            _b._jobs = new Slice<stdgo.regexp.Regexp.T_job>((0 : GoInt).toBasic(), (256 : GoInt));
        } else {
            _b._jobs = (_b._jobs.__slice__(0, (0 : GoInt)) : Slice<stdgo.regexp.Regexp.T_job>);
        };
        var _visitedSize:GoInt = (((_prog.inst.length * (_end + (1 : GoInt))) + (32 : GoInt)) - (1 : GoInt)) / (32 : GoInt);
        if (_b._visited.capacity < _visitedSize) {
            _b._visited = new Slice<GoUInt32>((_visitedSize : GoInt).toBasic(), (8192 : GoInt)).__setNumber32__();
        } else {
            _b._visited = (_b._visited.__slice__(0, _visitedSize) : Slice<GoUInt32>);
            for (_i in 0 ... _b._visited.length.toBasic()) {
                _b._visited[(_i : GoInt)] = (0u32 : GoUInt32);
            };
        };
        if (_b._cap.capacity < _ncap) {
            _b._cap = new Slice<GoInt>((_ncap : GoInt).toBasic(), 0).__setNumber32__();
        } else {
            _b._cap = (_b._cap.__slice__(0, _ncap) : Slice<GoInt>);
        };
        for (_i in 0 ... _b._cap.length.toBasic()) {
            _b._cap[(_i : GoInt)] = (-1 : GoInt);
        };
        if (_b._matchcap.capacity < _ncap) {
            _b._matchcap = new Slice<GoInt>((_ncap : GoInt).toBasic(), 0).__setNumber32__();
        } else {
            _b._matchcap = (_b._matchcap.__slice__(0, _ncap) : Slice<GoInt>);
        };
        for (_i in 0 ... _b._matchcap.length.toBasic()) {
            _b._matchcap[(_i : GoInt)] = (-1 : GoInt);
        };
    }
}
class T_machine_asInterface {
    /**
        // add adds an entry to q for pc, unless the q already has such an entry.
        // It also recursively adds an entry for all instructions reachable from pc by following
        // empty-width conditions satisfied by cond.  pos gives the current position
        // in the input.
    **/
    @:keep
    public dynamic function _add(_q:Ref<T_queue>, _pc:GoUInt32, _pos:GoInt, _cap:Slice<GoInt>, _cond:Pointer<T_lazyFlag>, _t:Ref<T_thread>):Ref<T_thread> return __self__.value._add(_q, _pc, _pos, _cap, _cond, _t);
    /**
        // step executes one step of the machine, running each of the threads
        // on runq and appending new threads to nextq.
        // The step processes the rune c (which may be endOfText),
        // which starts at position pos and ends at nextPos.
        // nextCond gives the setting for the empty-width flags after c.
    **/
    @:keep
    public dynamic function _step(_runq:Ref<T_queue>, _nextq:Ref<T_queue>, _pos:GoInt, _nextPos:GoInt, _c:GoRune, _nextCond:Pointer<T_lazyFlag>):Void __self__.value._step(_runq, _nextq, _pos, _nextPos, _c, _nextCond);
    /**
        // clear frees all threads on the thread queue.
    **/
    @:keep
    public dynamic function _clear(_q:Ref<T_queue>):Void __self__.value._clear(_q);
    /**
        // match runs the machine over the input starting at pos.
        // It reports whether a match was found.
        // If so, m.matchcap holds the submatch information.
    **/
    @:keep
    public dynamic function _match(_i:T_input, _pos:GoInt):Bool return __self__.value._match(_i, _pos);
    /**
        // alloc allocates a new thread with the given instruction.
        // It uses the free pool if possible.
    **/
    @:keep
    public dynamic function _alloc(_i:Ref<stdgo.regexp.syntax.Syntax.Inst>):Ref<T_thread> return __self__.value._alloc(_i);
    @:keep
    public dynamic function _init(_ncap:GoInt):Void __self__.value._init(_ncap);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_machine>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_machine_asInterface) class T_machine_static_extension {
    /**
        // add adds an entry to q for pc, unless the q already has such an entry.
        // It also recursively adds an entry for all instructions reachable from pc by following
        // empty-width conditions satisfied by cond.  pos gives the current position
        // in the input.
    **/
    @:keep
    static public function _add( _m:Ref<T_machine>, _q:Ref<T_queue>, _pc:GoUInt32, _pos:GoInt, _cap:Slice<GoInt>, _cond:Pointer<T_lazyFlag>, _t:Ref<T_thread>):Ref<T_thread> {
        stdgo.internal.Macro.controlFlow({
            @:label("Again") if (_pc == ((0u32 : GoUInt32))) {
                return _t;
            };
            {
                var _j:GoUInt32 = _q._sparse[(_pc : GoInt)];
                if ((_j < (_q._dense.length : GoUInt32)) && (_q._dense[(_j : GoInt)]._pc == _pc)) {
                    return _t;
                };
            };
            var _j:GoInt = (_q._dense.length);
            _q._dense = (_q._dense.__slice__(0, _j + (1 : GoInt)) : Slice<stdgo.regexp.Regexp.T_entry>);
            var _d = (Go.setRef(_q._dense[(_j : GoInt)]) : Ref<stdgo.regexp.Regexp.T_entry>);
            _d._t = null;
            _d._pc = _pc;
            _q._sparse[(_pc : GoInt)] = (_j : GoUInt32);
            var _i = (Go.setRef(_m._p.inst[(_pc : GoInt)]) : Ref<stdgo.regexp.syntax.Syntax.Inst>);
            {
                final __value__ = _i.op;
                if (__value__ == ((5 : stdgo.regexp.syntax.Syntax.InstOp))) {} else if (__value__ == ((0 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((1 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    _t = _m._add(_q, _i.out, _pos, _cap, _cond, _t);
                    _pc = _i.arg;
                    @:goto "Again";
                } else if (__value__ == ((3 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    if (_cond.value._match((_i.arg : stdgo.regexp.syntax.Syntax.EmptyOp))) {
                        _pc = _i.out;
                        @:goto "Again";
                    };
                } else if (__value__ == ((6 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    _pc = _i.out;
                    @:goto "Again";
                } else if (__value__ == ((2 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    if ((_i.arg : GoInt) < (_cap.length)) {
                        var _opos:GoInt = _cap[(_i.arg : GoInt)];
                        _cap[(_i.arg : GoInt)] = _pos;
                        _m._add(_q, _i.out, _pos, _cap, _cond, null);
                        _cap[(_i.arg : GoInt)] = _opos;
                    } else {
                        _pc = _i.out;
                        @:goto "Again";
                    };
                } else if (__value__ == ((4 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((7 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((8 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((9 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((10 : stdgo.regexp.syntax.Syntax.InstOp))) {
                    if (_t == null || (_t : Dynamic).__nil__) {
                        _t = _m._alloc(_i);
                    } else {
                        _t._inst = _i;
                    };
                    if ((_cap.length > (0 : GoInt)) && (Go.pointer(_t._cap[(0 : GoInt)]) != Go.pointer(_cap[(0 : GoInt)]))) {
                        Go.copySlice(_t._cap, _cap);
                    };
                    _d._t = _t;
                    _t = null;
                } else {
                    throw Go.toInterface(("unhandled" : GoString));
                };
            };
            return _t;
        });
        throw "controlFlow did not return";
    }
    /**
        // step executes one step of the machine, running each of the threads
        // on runq and appending new threads to nextq.
        // The step processes the rune c (which may be endOfText),
        // which starts at position pos and ends at nextPos.
        // nextCond gives the setting for the empty-width flags after c.
    **/
    @:keep
    static public function _step( _m:Ref<T_machine>, _runq:Ref<T_queue>, _nextq:Ref<T_queue>, _pos:GoInt, _nextPos:GoInt, _c:GoRune, _nextCond:Pointer<T_lazyFlag>):Void {
        var _longest:Bool = _m._re._longest;
        {
            var _j:GoInt = (0 : GoInt);
            Go.cfor(_j < (_runq._dense.length), _j++, {
                var _d = (Go.setRef(_runq._dense[(_j : GoInt)]) : Ref<stdgo.regexp.Regexp.T_entry>);
                var _t = _d._t;
                if (_t == null || (_t : Dynamic).__nil__) {
                    continue;
                };
                if (((_longest && _m._matched) && (_t._cap.length > (0 : GoInt))) && (_m._matchcap[(0 : GoInt)] < _t._cap[(0 : GoInt)])) {
                    _m._pool = (_m._pool.__append__(_t));
                    continue;
                };
                var _i = _t._inst;
                var _add:Bool = false;
                {
                    final __value__ = _i.op;
                    if (__value__ == ((4 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if ((_t._cap.length > (0 : GoInt)) && ((!_longest || !_m._matched) || (_m._matchcap[(1 : GoInt)] < _pos))) {
                            _t._cap[(1 : GoInt)] = _pos;
                            Go.copySlice(_m._matchcap, _t._cap);
                        };
                        if (!_longest) {
                            for (__0 => _d in (_runq._dense.__slice__(_j + (1 : GoInt)) : Slice<stdgo.regexp.Regexp.T_entry>)) {
                                if (_d._t != null && ((_d._t : Dynamic).__nil__ == null || !(_d._t : Dynamic).__nil__)) {
                                    _m._pool = (_m._pool.__append__(_d._t));
                                };
                            };
                            _runq._dense = (_runq._dense.__slice__(0, (0 : GoInt)) : Slice<stdgo.regexp.Regexp.T_entry>);
                        };
                        _m._matched = true;
                    } else if (__value__ == ((7 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        _add = _i.matchRune(_c);
                    } else if (__value__ == ((8 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        _add = _c == (_i.rune[((0 : GoInt) : GoInt)]);
                    } else if (__value__ == ((9 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        _add = true;
                    } else if (__value__ == ((10 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        _add = _c != ((10 : GoInt32));
                    } else {
                        throw Go.toInterface(("bad inst" : GoString));
                    };
                };
                if (_add) {
                    _t = _m._add(_nextq, _i.out, _nextPos, _t._cap, _nextCond, _t);
                };
                if (_t != null && ((_t : Dynamic).__nil__ == null || !(_t : Dynamic).__nil__)) {
                    _m._pool = (_m._pool.__append__(_t));
                };
            });
        };
        _runq._dense = (_runq._dense.__slice__(0, (0 : GoInt)) : Slice<stdgo.regexp.Regexp.T_entry>);
    }
    /**
        // clear frees all threads on the thread queue.
    **/
    @:keep
    static public function _clear( _m:Ref<T_machine>, _q:Ref<T_queue>):Void {
        for (__0 => _d in _q._dense) {
            if (_d._t != null && ((_d._t : Dynamic).__nil__ == null || !(_d._t : Dynamic).__nil__)) {
                _m._pool = (_m._pool.__append__(_d._t));
            };
        };
        _q._dense = (_q._dense.__slice__(0, (0 : GoInt)) : Slice<stdgo.regexp.Regexp.T_entry>);
    }
    /**
        // match runs the machine over the input starting at pos.
        // It reports whether a match was found.
        // If so, m.matchcap holds the submatch information.
    **/
    @:keep
    static public function _match( _m:Ref<T_machine>, _i:T_input, _pos:GoInt):Bool {
        var _startCond:stdgo.regexp.syntax.Syntax.EmptyOp = _m._re._cond;
        if (_startCond == ((255 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            return false;
        };
        _m._matched = false;
        for (_i in 0 ... _m._matchcap.length.toBasic()) {
            _m._matchcap[(_i : GoInt)] = (-1 : GoInt);
        };
        var __0 = (Go.setRef(_m._q0) : Ref<stdgo.regexp.Regexp.T_queue>), __1 = (Go.setRef(_m._q1) : Ref<stdgo.regexp.Regexp.T_queue>), _nextq = __1, _runq = __0;
        var __0:GoInt32 = (-1 : GoInt32), __1:GoInt32 = (-1 : GoInt32), _r1:GoInt32 = __1, _r:GoInt32 = __0;
        var __0:GoInt = (0 : GoInt), __1:GoInt = (0 : GoInt), _width1:GoInt = __1, _width:GoInt = __0;
        {
            var __tmp__ = _i._step(_pos);
            _r = __tmp__._0;
            _width = __tmp__._1;
        };
        if (_r != ((-1 : GoInt32))) {
            {
                var __tmp__ = _i._step(_pos + _width);
                _r1 = __tmp__._0;
                _width1 = __tmp__._1;
            };
        };
        var _flag:T_lazyFlag = ((0 : GoUInt64) : stdgo.regexp.Regexp.T_lazyFlag);
        if (_pos == ((0 : GoInt))) {
            _flag = _newLazyFlag((-1 : GoInt32), _r);
        } else {
            _flag = _i._context(_pos);
        };
        while (true) {
            if ((_runq._dense.length) == ((0 : GoInt))) {
                if (((_startCond & (4 : stdgo.regexp.syntax.Syntax.EmptyOp)) != (0 : stdgo.regexp.syntax.Syntax.EmptyOp)) && (_pos != (0 : GoInt))) {
                    break;
                };
                if (_m._matched) {
                    break;
                };
                if (((_m._re._prefix.length > (0 : GoInt)) && (_r1 != _m._re._prefixRune)) && _i._canCheckPrefix()) {
                    var _advance:GoInt = _i._index(_m._re, _pos);
                    if (_advance < (0 : GoInt)) {
                        break;
                    };
                    _pos = _pos + (_advance);
                    {
                        var __tmp__ = _i._step(_pos);
                        _r = __tmp__._0;
                        _width = __tmp__._1;
                    };
                    {
                        var __tmp__ = _i._step(_pos + _width);
                        _r1 = __tmp__._0;
                        _width1 = __tmp__._1;
                    };
                };
            };
            if (!_m._matched) {
                if ((_m._matchcap.length) > (0 : GoInt)) {
                    _m._matchcap[(0 : GoInt)] = _pos;
                };
                _m._add(_runq, (_m._p.start : GoUInt32), _pos, _m._matchcap, Go.pointer(_flag), null);
            };
            _flag = _newLazyFlag(_r, _r1);
            _m._step(_runq, _nextq, _pos, _pos + _width, _r, Go.pointer(_flag));
            if (_width == ((0 : GoInt))) {
                break;
            };
            if ((_m._matchcap.length == (0 : GoInt)) && _m._matched) {
                break;
            };
            _pos = _pos + (_width);
            {
                final __tmp__0 = _r1;
                final __tmp__1 = _width1;
                _r = __tmp__0;
                _width = __tmp__1;
            };
            if (_r != ((-1 : GoInt32))) {
                {
                    var __tmp__ = _i._step(_pos + _width);
                    _r1 = __tmp__._0;
                    _width1 = __tmp__._1;
                };
            };
            {
                final __tmp__0 = _nextq;
                final __tmp__1 = _runq;
                _runq = __tmp__0;
                _nextq = __tmp__1;
            };
        };
        _m._clear(_nextq);
        return _m._matched;
    }
    /**
        // alloc allocates a new thread with the given instruction.
        // It uses the free pool if possible.
    **/
    @:keep
    static public function _alloc( _m:Ref<T_machine>, _i:Ref<stdgo.regexp.syntax.Syntax.Inst>):Ref<T_thread> {
        var _t:Ref<T_thread> = (null : Ref<stdgo.regexp.Regexp.T_thread>);
        {
            var _n:GoInt = (_m._pool.length);
            if (_n > (0 : GoInt)) {
                _t = _m._pool[(_n - (1 : GoInt) : GoInt)];
                _m._pool = (_m._pool.__slice__(0, _n - (1 : GoInt)) : Slice<Ref<stdgo.regexp.Regexp.T_thread>>);
            } else {
                _t = (Go.setRef(({} : stdgo.regexp.Regexp.T_thread)) : Ref<stdgo.regexp.Regexp.T_thread>);
                _t._cap = new Slice<GoInt>((_m._matchcap.length : GoInt).toBasic(), _m._matchcap.capacity).__setNumber32__();
            };
        };
        _t._inst = _i;
        return _t;
    }
    @:keep
    static public function _init( _m:Ref<T_machine>, _ncap:GoInt):Void {
        for (__0 => _t in _m._pool) {
            _t._cap = (_t._cap.__slice__(0, _ncap) : Slice<GoInt>);
        };
        _m._matchcap = (_m._matchcap.__slice__(0, _ncap) : Slice<GoInt>);
    }
}
class T_inputs_asInterface {
    @:keep
    public dynamic function _init(_r:stdgo.io.Io.RuneReader, _b:Slice<GoByte>, _s:GoString):{ var _0 : T_input; var _1 : GoInt; } return __self__.value._init(_r, _b, _s);
    @:keep
    public dynamic function _clear():Void __self__.value._clear();
    @:keep
    public dynamic function _newReader(_r:stdgo.io.Io.RuneReader):T_input return __self__.value._newReader(_r);
    @:keep
    public dynamic function _newString(_s:GoString):T_input return __self__.value._newString(_s);
    @:keep
    public dynamic function _newBytes(_b:Slice<GoByte>):T_input return __self__.value._newBytes(_b);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_inputs>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_inputs_asInterface) class T_inputs_static_extension {
    @:keep
    static public function _init( _i:Ref<T_inputs>, _r:stdgo.io.Io.RuneReader, _b:Slice<GoByte>, _s:GoString):{ var _0 : T_input; var _1 : GoInt; } {
        if (_r != null) {
            return { _0 : _i._newReader(_r), _1 : (0 : GoInt) };
        };
        if (_b != null) {
            return { _0 : _i._newBytes(_b), _1 : (_b.length) };
        };
        return { _0 : _i._newString(_s), _1 : (_s.length) };
    }
    @:keep
    static public function _clear( _i:Ref<T_inputs>):Void {
        if (_i._bytes._str != null) {
            _i._bytes._str = (null : Slice<GoUInt8>);
        } else if (_i._reader._r != null) {
            _i._reader._r = (null : stdgo.io.Io.RuneReader);
        } else {
            _i._string._str = Go.str();
        };
    }
    @:keep
    static public function _newReader( _i:Ref<T_inputs>, _r:stdgo.io.Io.RuneReader):T_input {
        _i._reader._r = _r;
        _i._reader._atEOT = false;
        _i._reader._pos = (0 : GoInt);
        return Go.asInterface((Go.setRef(_i._reader) : Ref<stdgo.regexp.Regexp.T_inputReader>));
    }
    @:keep
    static public function _newString( _i:Ref<T_inputs>, _s:GoString):T_input {
        _i._string._str = _s;
        return Go.asInterface((Go.setRef(_i._string) : Ref<stdgo.regexp.Regexp.T_inputString>));
    }
    @:keep
    static public function _newBytes( _i:Ref<T_inputs>, _b:Slice<GoByte>):T_input {
        _i._bytes._str = _b;
        return Go.asInterface((Go.setRef(_i._bytes) : Ref<stdgo.regexp.Regexp.T_inputBytes>));
    }
}
class T_onePassInst_asInterface {
    @:embedded
    public dynamic function _op():stdgo.regexp.syntax.Syntax.InstOp return __self__.value._op();
    @:embedded
    public dynamic function string():GoString return __self__.value.string();
    @:embedded
    public dynamic function matchRunePos(_r:GoInt32):GoInt return __self__.value.matchRunePos(_r);
    @:embedded
    public dynamic function matchRune(_r:GoInt32):Bool return __self__.value.matchRune(_r);
    @:embedded
    public dynamic function matchEmptyWidth(_before:GoInt32, _after:GoInt32):Bool return __self__.value.matchEmptyWidth(_before, _after);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_onePassInst>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_onePassInst_asInterface) class T_onePassInst_static_extension {
    @:embedded
    public static function _op( __self__:T_onePassInst):stdgo.regexp.syntax.Syntax.InstOp return __self__._op();
    @:embedded
    public static function string( __self__:T_onePassInst):GoString return __self__.string();
    @:embedded
    public static function matchRunePos( __self__:T_onePassInst, _r:GoInt32):GoInt return __self__.matchRunePos(_r);
    @:embedded
    public static function matchRune( __self__:T_onePassInst, _r:GoInt32):Bool return __self__.matchRune(_r);
    @:embedded
    public static function matchEmptyWidth( __self__:T_onePassInst, _before:GoInt32, _after:GoInt32):Bool return __self__.matchEmptyWidth(_before, _after);
}
class T_queueOnePass_asInterface {
    @:keep
    public dynamic function _insertNew(_u:GoUInt32):Void __self__.value._insertNew(_u);
    @:keep
    public dynamic function _insert(_u:GoUInt32):Void __self__.value._insert(_u);
    @:keep
    public dynamic function _contains(_u:GoUInt32):Bool return __self__.value._contains(_u);
    @:keep
    public dynamic function _clear():Void __self__.value._clear();
    @:keep
    public dynamic function _next():GoUInt32 return __self__.value._next();
    @:keep
    public dynamic function _empty():Bool return __self__.value._empty();
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_queueOnePass>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_queueOnePass_asInterface) class T_queueOnePass_static_extension {
    @:keep
    static public function _insertNew( _q:Ref<T_queueOnePass>, _u:GoUInt32):Void {
        if (_u >= (_q._sparse.length : GoUInt32)) {
            return;
        };
        _q._sparse[(_u : GoInt)] = _q._size;
        _q._dense[(_q._size : GoInt)] = _u;
        _q._size++;
    }
    @:keep
    static public function _insert( _q:Ref<T_queueOnePass>, _u:GoUInt32):Void {
        if (!_q._contains(_u)) {
            _q._insertNew(_u);
        };
    }
    @:keep
    static public function _contains( _q:Ref<T_queueOnePass>, _u:GoUInt32):Bool {
        if (_u >= (_q._sparse.length : GoUInt32)) {
            return false;
        };
        return (_q._sparse[(_u : GoInt)] < _q._size) && (_q._dense[(_q._sparse[(_u : GoInt)] : GoInt)] == _u);
    }
    @:keep
    static public function _clear( _q:Ref<T_queueOnePass>):Void {
        _q._size = (0u32 : GoUInt32);
        _q._nextIndex = (0u32 : GoUInt32);
    }
    @:keep
    static public function _next( _q:Ref<T_queueOnePass>):GoUInt32 {
        var _n:GoUInt32 = (0 : GoUInt32);
        _n = _q._dense[(_q._nextIndex : GoInt)];
        _q._nextIndex++;
        return _n;
    }
    @:keep
    static public function _empty( _q:Ref<T_queueOnePass>):Bool {
        return _q._nextIndex >= _q._size;
    }
}
class Regexp_asInterface {
    /**
        // Split slices s into substrings separated by the expression and returns a slice of
        // the substrings between those expression matches.
        //
        // The slice returned by this method consists of all the substrings of s
        // not contained in the slice returned by FindAllString. When called on an expression
        // that contains no metacharacters, it is equivalent to strings.SplitN.
        //
        // Example:
        //
        //	s := regexp.MustCompile("a*").Split("abaabaccadaaae", 5)
        //	// s: ["", "b", "b", "c", "cadaaae"]
        //
        // The count determines the number of substrings to return:
        //
        //	n > 0: at most n substrings; the last substring will be the unsplit remainder.
        //	n == 0: the result is nil (zero substrings)
        //	n < 0: all substrings
    **/
    @:keep
    public dynamic function split(_s:GoString, _n:GoInt):Slice<GoString> return __self__.value.split(_s, _n);
    /**
        // FindAllStringSubmatchIndex is the 'All' version of
        // FindStringSubmatchIndex; it returns a slice of all successive matches of
        // the expression, as defined by the 'All' description in the package
        // comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findAllStringSubmatchIndex(_s:GoString, _n:GoInt):Slice<Slice<GoInt>> return __self__.value.findAllStringSubmatchIndex(_s, _n);
    /**
        // FindAllStringSubmatch is the 'All' version of FindStringSubmatch; it
        // returns a slice of all successive matches of the expression, as defined by
        // the 'All' description in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findAllStringSubmatch(_s:GoString, _n:GoInt):Slice<Slice<GoString>> return __self__.value.findAllStringSubmatch(_s, _n);
    /**
        // FindAllSubmatchIndex is the 'All' version of FindSubmatchIndex; it returns
        // a slice of all successive matches of the expression, as defined by the
        // 'All' description in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findAllSubmatchIndex(_b:Slice<GoByte>, _n:GoInt):Slice<Slice<GoInt>> return __self__.value.findAllSubmatchIndex(_b, _n);
    /**
        // FindAllSubmatch is the 'All' version of FindSubmatch; it returns a slice
        // of all successive matches of the expression, as defined by the 'All'
        // description in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findAllSubmatch(_b:Slice<GoByte>, _n:GoInt):Slice<Slice<Slice<GoByte>>> return __self__.value.findAllSubmatch(_b, _n);
    /**
        // FindAllStringIndex is the 'All' version of FindStringIndex; it returns a
        // slice of all successive matches of the expression, as defined by the 'All'
        // description in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findAllStringIndex(_s:GoString, _n:GoInt):Slice<Slice<GoInt>> return __self__.value.findAllStringIndex(_s, _n);
    /**
        // FindAllString is the 'All' version of FindString; it returns a slice of all
        // successive matches of the expression, as defined by the 'All' description
        // in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findAllString(_s:GoString, _n:GoInt):Slice<GoString> return __self__.value.findAllString(_s, _n);
    /**
        // FindAllIndex is the 'All' version of FindIndex; it returns a slice of all
        // successive matches of the expression, as defined by the 'All' description
        // in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findAllIndex(_b:Slice<GoByte>, _n:GoInt):Slice<Slice<GoInt>> return __self__.value.findAllIndex(_b, _n);
    /**
        // FindAll is the 'All' version of Find; it returns a slice of all successive
        // matches of the expression, as defined by the 'All' description in the
        // package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findAll(_b:Slice<GoByte>, _n:GoInt):Slice<Slice<GoByte>> return __self__.value.findAll(_b, _n);
    /**
        // FindReaderSubmatchIndex returns a slice holding the index pairs
        // identifying the leftmost match of the regular expression of text read by
        // the RuneReader, and the matches, if any, of its subexpressions, as defined
        // by the 'Submatch' and 'Index' descriptions in the package comment. A
        // return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findReaderSubmatchIndex(_r:stdgo.io.Io.RuneReader):Slice<GoInt> return __self__.value.findReaderSubmatchIndex(_r);
    /**
        // FindStringSubmatchIndex returns a slice holding the index pairs
        // identifying the leftmost match of the regular expression in s and the
        // matches, if any, of its subexpressions, as defined by the 'Submatch' and
        // 'Index' descriptions in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findStringSubmatchIndex(_s:GoString):Slice<GoInt> return __self__.value.findStringSubmatchIndex(_s);
    /**
        // FindStringSubmatch returns a slice of strings holding the text of the
        // leftmost match of the regular expression in s and the matches, if any, of
        // its subexpressions, as defined by the 'Submatch' description in the
        // package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findStringSubmatch(_s:GoString):Slice<GoString> return __self__.value.findStringSubmatch(_s);
    /**
        // FindSubmatchIndex returns a slice holding the index pairs identifying the
        // leftmost match of the regular expression in b and the matches, if any, of
        // its subexpressions, as defined by the 'Submatch' and 'Index' descriptions
        // in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findSubmatchIndex(_b:Slice<GoByte>):Slice<GoInt> return __self__.value.findSubmatchIndex(_b);
    @:keep
    public dynamic function _expand(_dst:Slice<GoByte>, _template:GoString, _bsrc:Slice<GoByte>, _src:GoString, _match:Slice<GoInt>):Slice<GoByte> return __self__.value._expand(_dst, _template, _bsrc, _src, _match);
    /**
        // ExpandString is like Expand but the template and source are strings.
        // It appends to and returns a byte slice in order to give the calling
        // code control over allocation.
    **/
    @:keep
    public dynamic function expandString(_dst:Slice<GoByte>, _template:GoString, _src:GoString, _match:Slice<GoInt>):Slice<GoByte> return __self__.value.expandString(_dst, _template, _src, _match);
    /**
        // Expand appends template to dst and returns the result; during the
        // append, Expand replaces variables in the template with corresponding
        // matches drawn from src. The match slice should have been returned by
        // FindSubmatchIndex.
        //
        // In the template, a variable is denoted by a substring of the form
        // $name or ${name}, where name is a non-empty sequence of letters,
        // digits, and underscores. A purely numeric name like $1 refers to
        // the submatch with the corresponding index; other names refer to
        // capturing parentheses named with the (?P<name>...) syntax. A
        // reference to an out of range or unmatched index or a name that is not
        // present in the regular expression is replaced with an empty slice.
        //
        // In the $name form, name is taken to be as long as possible: $1x is
        // equivalent to ${1x}, not ${1}x, and, $10 is equivalent to ${10}, not ${1}0.
        //
        // To insert a literal $ in the output, use $$ in the template.
    **/
    @:keep
    public dynamic function expand(_dst:Slice<GoByte>, _template:Slice<GoByte>, _src:Slice<GoByte>, _match:Slice<GoInt>):Slice<GoByte> return __self__.value.expand(_dst, _template, _src, _match);
    /**
        // FindSubmatch returns a slice of slices holding the text of the leftmost
        // match of the regular expression in b and the matches, if any, of its
        // subexpressions, as defined by the 'Submatch' descriptions in the package
        // comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findSubmatch(_b:Slice<GoByte>):Slice<Slice<GoByte>> return __self__.value.findSubmatch(_b);
    /**
        // FindReaderIndex returns a two-element slice of integers defining the
        // location of the leftmost match of the regular expression in text read from
        // the RuneReader. The match text was found in the input stream at
        // byte offset loc[0] through loc[1]-1.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findReaderIndex(_r:stdgo.io.Io.RuneReader):Slice<GoInt> return __self__.value.findReaderIndex(_r);
    /**
        // FindStringIndex returns a two-element slice of integers defining the
        // location of the leftmost match in s of the regular expression. The match
        // itself is at s[loc[0]:loc[1]].
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findStringIndex(_s:GoString):Slice<GoInt> return __self__.value.findStringIndex(_s);
    /**
        // FindString returns a string holding the text of the leftmost match in s of the regular
        // expression. If there is no match, the return value is an empty string,
        // but it will also be empty if the regular expression successfully matches
        // an empty string. Use FindStringIndex or FindStringSubmatch if it is
        // necessary to distinguish these cases.
    **/
    @:keep
    public dynamic function findString(_s:GoString):GoString return __self__.value.findString(_s);
    /**
        // FindIndex returns a two-element slice of integers defining the location of
        // the leftmost match in b of the regular expression. The match itself is at
        // b[loc[0]:loc[1]].
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function findIndex(_b:Slice<GoByte>):Slice<GoInt> return __self__.value.findIndex(_b);
    /**
        // Find returns a slice holding the text of the leftmost match in b of the regular expression.
        // A return value of nil indicates no match.
    **/
    @:keep
    public dynamic function find(_b:Slice<GoByte>):Slice<GoByte> return __self__.value.find(_b);
    /**
        // allMatches calls deliver at most n times
        // with the location of successive matches in the input text.
        // The input text is b if non-nil, otherwise s.
    **/
    @:keep
    public dynamic function _allMatches(_s:GoString, _b:Slice<GoByte>, _n:GoInt, _deliver:Slice<GoInt> -> Void):Void __self__.value._allMatches(_s, _b, _n, _deliver);
    /**
        // The number of capture values in the program may correspond
        // to fewer capturing expressions than are in the regexp.
        // For example, "(a){0}" turns into an empty program, so the
        // maximum capture in the program is 0 but we need to return
        // an expression for \1.  Pad appends -1s to the slice a as needed.
    **/
    @:keep
    public dynamic function _pad(_a:Slice<GoInt>):Slice<GoInt> return __self__.value._pad(_a);
    /**
        // ReplaceAllFunc returns a copy of src in which all matches of the
        // Regexp have been replaced by the return value of function repl applied
        // to the matched byte slice. The replacement returned by repl is substituted
        // directly, without using Expand.
    **/
    @:keep
    public dynamic function replaceAllFunc(_src:Slice<GoByte>, _repl:Slice<GoByte> -> Slice<GoByte>):Slice<GoByte> return __self__.value.replaceAllFunc(_src, _repl);
    /**
        // ReplaceAllLiteral returns a copy of src, replacing matches of the Regexp
        // with the replacement bytes repl. The replacement repl is substituted directly,
        // without using Expand.
    **/
    @:keep
    public dynamic function replaceAllLiteral(_src:Slice<GoByte>, _repl:Slice<GoByte>):Slice<GoByte> return __self__.value.replaceAllLiteral(_src, _repl);
    /**
        // ReplaceAll returns a copy of src, replacing matches of the Regexp
        // with the replacement text repl. Inside repl, $ signs are interpreted as
        // in Expand, so for instance $1 represents the text of the first submatch.
    **/
    @:keep
    public dynamic function replaceAll(_src:Slice<GoByte>, _repl:Slice<GoByte>):Slice<GoByte> return __self__.value.replaceAll(_src, _repl);
    @:keep
    public dynamic function _replaceAll(_bsrc:Slice<GoByte>, _src:GoString, _nmatch:GoInt, _repl:(_dst:Slice<GoByte>, _m:Slice<GoInt>) -> Slice<GoByte>):Slice<GoByte> return __self__.value._replaceAll(_bsrc, _src, _nmatch, _repl);
    /**
        // ReplaceAllStringFunc returns a copy of src in which all matches of the
        // Regexp have been replaced by the return value of function repl applied
        // to the matched substring. The replacement returned by repl is substituted
        // directly, without using Expand.
    **/
    @:keep
    public dynamic function replaceAllStringFunc(_src:GoString, _repl:GoString -> GoString):GoString return __self__.value.replaceAllStringFunc(_src, _repl);
    /**
        // ReplaceAllLiteralString returns a copy of src, replacing matches of the Regexp
        // with the replacement string repl. The replacement repl is substituted directly,
        // without using Expand.
    **/
    @:keep
    public dynamic function replaceAllLiteralString(_src:GoString, _repl:GoString):GoString return __self__.value.replaceAllLiteralString(_src, _repl);
    /**
        // ReplaceAllString returns a copy of src, replacing matches of the Regexp
        // with the replacement string repl. Inside repl, $ signs are interpreted as
        // in Expand, so for instance $1 represents the text of the first submatch.
    **/
    @:keep
    public dynamic function replaceAllString(_src:GoString, _repl:GoString):GoString return __self__.value.replaceAllString(_src, _repl);
    /**
        // Match reports whether the byte slice b
        // contains any match of the regular expression re.
    **/
    @:keep
    public dynamic function match(_b:Slice<GoByte>):Bool return __self__.value.match(_b);
    /**
        // MatchString reports whether the string s
        // contains any match of the regular expression re.
    **/
    @:keep
    public dynamic function matchString(_s:GoString):Bool return __self__.value.matchString(_s);
    /**
        // MatchReader reports whether the text returned by the RuneReader
        // contains any match of the regular expression re.
    **/
    @:keep
    public dynamic function matchReader(_r:stdgo.io.Io.RuneReader):Bool return __self__.value.matchReader(_r);
    /**
        // LiteralPrefix returns a literal string that must begin any match
        // of the regular expression re. It returns the boolean true if the
        // literal string comprises the entire regular expression.
    **/
    @:keep
    public dynamic function literalPrefix():{ var _0 : GoString; var _1 : Bool; } return __self__.value.literalPrefix();
    /**
        // SubexpIndex returns the index of the first subexpression with the given name,
        // or -1 if there is no subexpression with that name.
        //
        // Note that multiple subexpressions can be written using the same name, as in
        // (?P<bob>a+)(?P<bob>b+), which declares two subexpressions named "bob".
        // In this case, SubexpIndex returns the index of the leftmost such subexpression
        // in the regular expression.
    **/
    @:keep
    public dynamic function subexpIndex(_name:GoString):GoInt return __self__.value.subexpIndex(_name);
    /**
        // SubexpNames returns the names of the parenthesized subexpressions
        // in this Regexp. The name for the first sub-expression is names[1],
        // so that if m is a match slice, the name for m[i] is SubexpNames()[i].
        // Since the Regexp as a whole cannot be named, names[0] is always
        // the empty string. The slice should not be modified.
    **/
    @:keep
    public dynamic function subexpNames():Slice<GoString> return __self__.value.subexpNames();
    /**
        // NumSubexp returns the number of parenthesized subexpressions in this Regexp.
    **/
    @:keep
    public dynamic function numSubexp():GoInt return __self__.value.numSubexp();
    /**
        // put returns a machine to the correct machine pool.
    **/
    @:keep
    public dynamic function _put(_m:Ref<T_machine>):Void __self__.value._put(_m);
    /**
        // get returns a machine to use for matching re.
        // It uses the re's machine cache if possible, to avoid
        // unnecessary allocation.
    **/
    @:keep
    public dynamic function _get():Ref<T_machine> return __self__.value._get();
    /**
        // Longest makes future searches prefer the leftmost-longest match.
        // That is, when matching against text, the regexp returns a match that
        // begins as early as possible in the input (leftmost), and among those
        // it chooses a match that is as long as possible.
        // This method modifies the Regexp and may not be called concurrently
        // with any other methods.
    **/
    @:keep
    public dynamic function longest():Void __self__.value.longest();
    /**
        // Copy returns a new Regexp object copied from re.
        // Calling Longest on one copy does not affect another.
        //
        // Deprecated: In earlier releases, when using a Regexp in multiple goroutines,
        // giving each goroutine its own copy helped to avoid lock contention.
        // As of Go 1.12, using Copy is no longer necessary to avoid lock contention.
        // Copy may still be appropriate if the reason for its use is to make
        // two copies with different Longest settings.
    **/
    @:keep
    public dynamic function copy():Ref<Regexp> return __self__.value.copy();
    /**
        // String returns the source text used to compile the regular expression.
    **/
    @:keep
    public dynamic function string():GoString return __self__.value.string();
    /**
        // doExecute finds the leftmost match in the input, appends the position
        // of its subexpressions to dstCap and returns dstCap.
        //
        // nil is returned if no matches are found and non-nil if matches are found.
    **/
    @:keep
    public dynamic function _doExecute(_r:stdgo.io.Io.RuneReader, _b:Slice<GoByte>, _s:GoString, _pos:GoInt, _ncap:GoInt, _dstCap:Slice<GoInt>):Slice<GoInt> return __self__.value._doExecute(_r, _b, _s, _pos, _ncap, _dstCap);
    /**
        // doMatch reports whether either r, b or s match the regexp.
    **/
    @:keep
    public dynamic function _doMatch(_r:stdgo.io.Io.RuneReader, _b:Slice<GoByte>, _s:GoString):Bool return __self__.value._doMatch(_r, _b, _s);
    /**
        // doOnePass implements r.doExecute using the one-pass execution engine.
    **/
    @:keep
    public dynamic function _doOnePass(_ir:stdgo.io.Io.RuneReader, _ib:Slice<GoByte>, _is:GoString, _pos:GoInt, _ncap:GoInt, _dstCap:Slice<GoInt>):Slice<GoInt> return __self__.value._doOnePass(_ir, _ib, _is, _pos, _ncap, _dstCap);
    /**
        // backtrack runs a backtracking search of prog on the input starting at pos.
    **/
    @:keep
    public dynamic function _backtrack(_ib:Slice<GoByte>, _is:GoString, _pos:GoInt, _ncap:GoInt, _dstCap:Slice<GoInt>):Slice<GoInt> return __self__.value._backtrack(_ib, _is, _pos, _ncap, _dstCap);
    /**
        // tryBacktrack runs a backtracking search starting at pos.
    **/
    @:keep
    public dynamic function _tryBacktrack(_b:Ref<T_bitState>, _i:T_input, _pc:GoUInt32, _pos:GoInt):Bool return __self__.value._tryBacktrack(_b, _i, _pc, _pos);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<Regexp>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.Regexp_asInterface) class Regexp_static_extension {
    /**
        // Split slices s into substrings separated by the expression and returns a slice of
        // the substrings between those expression matches.
        //
        // The slice returned by this method consists of all the substrings of s
        // not contained in the slice returned by FindAllString. When called on an expression
        // that contains no metacharacters, it is equivalent to strings.SplitN.
        //
        // Example:
        //
        //	s := regexp.MustCompile("a*").Split("abaabaccadaaae", 5)
        //	// s: ["", "b", "b", "c", "cadaaae"]
        //
        // The count determines the number of substrings to return:
        //
        //	n > 0: at most n substrings; the last substring will be the unsplit remainder.
        //	n == 0: the result is nil (zero substrings)
        //	n < 0: all substrings
    **/
    @:keep
    static public function split( _re:Ref<Regexp>, _s:GoString, _n:GoInt):Slice<GoString> {
        if (_n == ((0 : GoInt))) {
            return (null : Slice<GoString>);
        };
        if ((_re._expr.length > (0 : GoInt)) && (_s.length == (0 : GoInt))) {
            return (new Slice<GoString>(0, 0, Go.str()) : Slice<GoString>);
        };
        var _matches = _re.findAllStringIndex(_s, _n);
        var _strings = new Slice<GoString>((0 : GoInt).toBasic(), (_matches.length)).__setString__();
        var _beg:GoInt = (0 : GoInt);
        var _end:GoInt = (0 : GoInt);
        for (__0 => _match in _matches) {
            if ((_n > (0 : GoInt)) && (_strings.length >= (_n - (1 : GoInt)))) {
                break;
            };
            _end = _match[(0 : GoInt)];
            if (_match[(1 : GoInt)] != ((0 : GoInt))) {
                _strings = (_strings.__append__((_s.__slice__(_beg, _end) : GoString)));
            };
            _beg = _match[(1 : GoInt)];
        };
        if (_end != ((_s.length))) {
            _strings = (_strings.__append__((_s.__slice__(_beg) : GoString)));
        };
        return _strings;
    }
    /**
        // FindAllStringSubmatchIndex is the 'All' version of
        // FindStringSubmatchIndex; it returns a slice of all successive matches of
        // the expression, as defined by the 'All' description in the package
        // comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findAllStringSubmatchIndex( _re:Ref<Regexp>, _s:GoString, _n:GoInt):Slice<Slice<GoInt>> {
        if (_n < (0 : GoInt)) {
            _n = (_s.length) + (1 : GoInt);
        };
        var _result:Slice<Slice<GoInt>> = (null : Slice<Slice<GoInt>>);
        _re._allMatches(_s, (null : Slice<GoUInt8>), _n, function(_match:Slice<GoInt>):Void {
            if (_result == null) {
                _result = new Slice<Slice<GoInt>>((0 : GoInt).toBasic(), (10 : GoInt));
            };
            _result = (_result.__append__(_match));
        });
        return _result;
    }
    /**
        // FindAllStringSubmatch is the 'All' version of FindStringSubmatch; it
        // returns a slice of all successive matches of the expression, as defined by
        // the 'All' description in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findAllStringSubmatch( _re:Ref<Regexp>, _s:GoString, _n:GoInt):Slice<Slice<GoString>> {
        if (_n < (0 : GoInt)) {
            _n = (_s.length) + (1 : GoInt);
        };
        var _result:Slice<Slice<GoString>> = (null : Slice<Slice<GoString>>);
        _re._allMatches(_s, (null : Slice<GoUInt8>), _n, function(_match:Slice<GoInt>):Void {
            if (_result == null) {
                _result = new Slice<Slice<GoString>>((0 : GoInt).toBasic(), (10 : GoInt));
            };
            var _slice = new Slice<GoString>(((_match.length) / (2 : GoInt) : GoInt).toBasic(), 0).__setString__();
            for (_j in 0 ... _slice.length.toBasic()) {
                if (_match[((2 : GoInt) * _j : GoInt)] >= (0 : GoInt)) {
                    _slice[(_j : GoInt)] = (_s.__slice__(_match[((2 : GoInt) * _j : GoInt)], _match[(((2 : GoInt) * _j) + (1 : GoInt) : GoInt)]) : GoString);
                };
            };
            _result = (_result.__append__(_slice));
        });
        return _result;
    }
    /**
        // FindAllSubmatchIndex is the 'All' version of FindSubmatchIndex; it returns
        // a slice of all successive matches of the expression, as defined by the
        // 'All' description in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findAllSubmatchIndex( _re:Ref<Regexp>, _b:Slice<GoByte>, _n:GoInt):Slice<Slice<GoInt>> {
        if (_n < (0 : GoInt)) {
            _n = (_b.length) + (1 : GoInt);
        };
        var _result:Slice<Slice<GoInt>> = (null : Slice<Slice<GoInt>>);
        _re._allMatches(Go.str(), _b, _n, function(_match:Slice<GoInt>):Void {
            if (_result == null) {
                _result = new Slice<Slice<GoInt>>((0 : GoInt).toBasic(), (10 : GoInt));
            };
            _result = (_result.__append__(_match));
        });
        return _result;
    }
    /**
        // FindAllSubmatch is the 'All' version of FindSubmatch; it returns a slice
        // of all successive matches of the expression, as defined by the 'All'
        // description in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findAllSubmatch( _re:Ref<Regexp>, _b:Slice<GoByte>, _n:GoInt):Slice<Slice<Slice<GoByte>>> {
        if (_n < (0 : GoInt)) {
            _n = (_b.length) + (1 : GoInt);
        };
        var _result:Slice<Slice<Slice<GoByte>>> = (null : Slice<Slice<Slice<GoUInt8>>>);
        _re._allMatches(Go.str(), _b, _n, function(_match:Slice<GoInt>):Void {
            if (_result == null) {
                _result = new Slice<Slice<Slice<GoUInt8>>>((0 : GoInt).toBasic(), (10 : GoInt));
            };
            var _slice = new Slice<Slice<GoUInt8>>(((_match.length) / (2 : GoInt) : GoInt).toBasic(), 0);
            for (_j in 0 ... _slice.length.toBasic()) {
                if (_match[((2 : GoInt) * _j : GoInt)] >= (0 : GoInt)) {
                    _slice[(_j : GoInt)] = (_b.__slice__(_match[((2 : GoInt) * _j : GoInt)], _match[(((2 : GoInt) * _j) + (1 : GoInt) : GoInt)], _match[(((2 : GoInt) * _j) + (1 : GoInt) : GoInt)]) : Slice<GoUInt8>);
                };
            };
            _result = (_result.__append__(_slice));
        });
        return _result;
    }
    /**
        // FindAllStringIndex is the 'All' version of FindStringIndex; it returns a
        // slice of all successive matches of the expression, as defined by the 'All'
        // description in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findAllStringIndex( _re:Ref<Regexp>, _s:GoString, _n:GoInt):Slice<Slice<GoInt>> {
        if (_n < (0 : GoInt)) {
            _n = (_s.length) + (1 : GoInt);
        };
        var _result:Slice<Slice<GoInt>> = (null : Slice<Slice<GoInt>>);
        _re._allMatches(_s, (null : Slice<GoUInt8>), _n, function(_match:Slice<GoInt>):Void {
            if (_result == null) {
                _result = new Slice<Slice<GoInt>>((0 : GoInt).toBasic(), (10 : GoInt));
            };
            _result = (_result.__append__((_match.__slice__((0 : GoInt), (2 : GoInt)) : Slice<GoInt>)));
        });
        return _result;
    }
    /**
        // FindAllString is the 'All' version of FindString; it returns a slice of all
        // successive matches of the expression, as defined by the 'All' description
        // in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findAllString( _re:Ref<Regexp>, _s:GoString, _n:GoInt):Slice<GoString> {
        if (_n < (0 : GoInt)) {
            _n = (_s.length) + (1 : GoInt);
        };
        var _result:Slice<GoString> = (null : Slice<GoString>);
        _re._allMatches(_s, (null : Slice<GoUInt8>), _n, function(_match:Slice<GoInt>):Void {
            if (_result == null) {
                _result = new Slice<GoString>((0 : GoInt).toBasic(), (10 : GoInt)).__setString__();
            };
            _result = (_result.__append__((_s.__slice__(_match[(0 : GoInt)], _match[(1 : GoInt)]) : GoString)));
        });
        return _result;
    }
    /**
        // FindAllIndex is the 'All' version of FindIndex; it returns a slice of all
        // successive matches of the expression, as defined by the 'All' description
        // in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findAllIndex( _re:Ref<Regexp>, _b:Slice<GoByte>, _n:GoInt):Slice<Slice<GoInt>> {
        if (_n < (0 : GoInt)) {
            _n = (_b.length) + (1 : GoInt);
        };
        var _result:Slice<Slice<GoInt>> = (null : Slice<Slice<GoInt>>);
        _re._allMatches(Go.str(), _b, _n, function(_match:Slice<GoInt>):Void {
            if (_result == null) {
                _result = new Slice<Slice<GoInt>>((0 : GoInt).toBasic(), (10 : GoInt));
            };
            _result = (_result.__append__((_match.__slice__((0 : GoInt), (2 : GoInt)) : Slice<GoInt>)));
        });
        return _result;
    }
    /**
        // FindAll is the 'All' version of Find; it returns a slice of all successive
        // matches of the expression, as defined by the 'All' description in the
        // package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findAll( _re:Ref<Regexp>, _b:Slice<GoByte>, _n:GoInt):Slice<Slice<GoByte>> {
        if (_n < (0 : GoInt)) {
            _n = (_b.length) + (1 : GoInt);
        };
        var _result:Slice<Slice<GoByte>> = (null : Slice<Slice<GoUInt8>>);
        _re._allMatches(Go.str(), _b, _n, function(_match:Slice<GoInt>):Void {
            if (_result == null) {
                _result = new Slice<Slice<GoUInt8>>((0 : GoInt).toBasic(), (10 : GoInt));
            };
            _result = (_result.__append__((_b.__slice__(_match[(0 : GoInt)], _match[(1 : GoInt)], _match[(1 : GoInt)]) : Slice<GoUInt8>)));
        });
        return _result;
    }
    /**
        // FindReaderSubmatchIndex returns a slice holding the index pairs
        // identifying the leftmost match of the regular expression of text read by
        // the RuneReader, and the matches, if any, of its subexpressions, as defined
        // by the 'Submatch' and 'Index' descriptions in the package comment. A
        // return value of nil indicates no match.
    **/
    @:keep
    static public function findReaderSubmatchIndex( _re:Ref<Regexp>, _r:stdgo.io.Io.RuneReader):Slice<GoInt> {
        return _re._pad(_re._doExecute(_r, (null : Slice<GoUInt8>), Go.str(), (0 : GoInt), _re._prog.numCap, (null : Slice<GoInt>)));
    }
    /**
        // FindStringSubmatchIndex returns a slice holding the index pairs
        // identifying the leftmost match of the regular expression in s and the
        // matches, if any, of its subexpressions, as defined by the 'Submatch' and
        // 'Index' descriptions in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findStringSubmatchIndex( _re:Ref<Regexp>, _s:GoString):Slice<GoInt> {
        return _re._pad(_re._doExecute((null : stdgo.io.Io.RuneReader), (null : Slice<GoUInt8>), _s, (0 : GoInt), _re._prog.numCap, (null : Slice<GoInt>)));
    }
    /**
        // FindStringSubmatch returns a slice of strings holding the text of the
        // leftmost match of the regular expression in s and the matches, if any, of
        // its subexpressions, as defined by the 'Submatch' description in the
        // package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findStringSubmatch( _re:Ref<Regexp>, _s:GoString):Slice<GoString> {
        var _dstCap:GoArray<GoInt> = new GoArray<GoInt>(...[for (i in 0 ... 4) (0 : GoInt)]);
        var _a = _re._doExecute((null : stdgo.io.Io.RuneReader), (null : Slice<GoUInt8>), _s, (0 : GoInt), _re._prog.numCap, (_dstCap.__slice__(0, (0 : GoInt)) : Slice<GoInt>));
        if (_a == null) {
            return (null : Slice<GoString>);
        };
        var _ret = new Slice<GoString>(((1 : GoInt) + _re._numSubexp : GoInt).toBasic(), 0).__setString__();
        for (_i in 0 ... _ret.length.toBasic()) {
            if ((((2 : GoInt) * _i) < _a.length) && (_a[((2 : GoInt) * _i : GoInt)] >= (0 : GoInt))) {
                _ret[(_i : GoInt)] = (_s.__slice__(_a[((2 : GoInt) * _i : GoInt)], _a[(((2 : GoInt) * _i) + (1 : GoInt) : GoInt)]) : GoString);
            };
        };
        return _ret;
    }
    /**
        // FindSubmatchIndex returns a slice holding the index pairs identifying the
        // leftmost match of the regular expression in b and the matches, if any, of
        // its subexpressions, as defined by the 'Submatch' and 'Index' descriptions
        // in the package comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findSubmatchIndex( _re:Ref<Regexp>, _b:Slice<GoByte>):Slice<GoInt> {
        return _re._pad(_re._doExecute((null : stdgo.io.Io.RuneReader), _b, Go.str(), (0 : GoInt), _re._prog.numCap, (null : Slice<GoInt>)));
    }
    @:keep
    static public function _expand( _re:Ref<Regexp>, _dst:Slice<GoByte>, _template:GoString, _bsrc:Slice<GoByte>, _src:GoString, _match:Slice<GoInt>):Slice<GoByte> {
        while ((_template.length) > (0 : GoInt)) {
            var __tmp__ = stdgo.strings.Strings.cut(_template, ("$$" : GoString)), _before:GoString = __tmp__._0, _after:GoString = __tmp__._1, _ok:Bool = __tmp__._2;
            if (!_ok) {
                break;
            };
            _dst = (_dst.__append__(..._before.__toArray__()));
            _template = _after;
            if ((_template != Go.str()) && (_template[(0 : GoInt)] == (36 : GoUInt8))) {
                _dst = (_dst.__append__((36 : GoUInt8)));
                _template = (_template.__slice__((1 : GoInt)) : GoString);
                continue;
            };
            var __tmp__ = _extract(_template), _name:GoString = __tmp__._0, _num:GoInt = __tmp__._1, _rest:GoString = __tmp__._2, _ok:Bool = __tmp__._3;
            if (!_ok) {
                _dst = (_dst.__append__((36 : GoUInt8)));
                continue;
            };
            _template = _rest;
            if (_num >= (0 : GoInt)) {
                if (((((2 : GoInt) * _num) + (1 : GoInt)) < _match.length) && (_match[((2 : GoInt) * _num : GoInt)] >= (0 : GoInt))) {
                    if (_bsrc != null) {
                        _dst = (_dst.__append__(...(_bsrc.__slice__(_match[((2 : GoInt) * _num : GoInt)], _match[(((2 : GoInt) * _num) + (1 : GoInt) : GoInt)]) : Slice<GoUInt8>).__toArray__()));
                    } else {
                        _dst = (_dst.__append__(...(_src.__slice__(_match[((2 : GoInt) * _num : GoInt)], _match[(((2 : GoInt) * _num) + (1 : GoInt) : GoInt)]) : GoString).__toArray__()));
                    };
                };
            } else {
                for (_i => _namei in _re._subexpNames) {
                    if (((_name == _namei) && ((((2 : GoInt) * _i) + (1 : GoInt)) < _match.length)) && (_match[((2 : GoInt) * _i : GoInt)] >= (0 : GoInt))) {
                        if (_bsrc != null) {
                            _dst = (_dst.__append__(...(_bsrc.__slice__(_match[((2 : GoInt) * _i : GoInt)], _match[(((2 : GoInt) * _i) + (1 : GoInt) : GoInt)]) : Slice<GoUInt8>).__toArray__()));
                        } else {
                            _dst = (_dst.__append__(...(_src.__slice__(_match[((2 : GoInt) * _i : GoInt)], _match[(((2 : GoInt) * _i) + (1 : GoInt) : GoInt)]) : GoString).__toArray__()));
                        };
                        break;
                    };
                };
            };
        };
        _dst = (_dst.__append__(..._template.__toArray__()));
        return _dst;
    }
    /**
        // ExpandString is like Expand but the template and source are strings.
        // It appends to and returns a byte slice in order to give the calling
        // code control over allocation.
    **/
    @:keep
    static public function expandString( _re:Ref<Regexp>, _dst:Slice<GoByte>, _template:GoString, _src:GoString, _match:Slice<GoInt>):Slice<GoByte> {
        return _re._expand(_dst, _template, (null : Slice<GoUInt8>), _src, _match);
    }
    /**
        // Expand appends template to dst and returns the result; during the
        // append, Expand replaces variables in the template with corresponding
        // matches drawn from src. The match slice should have been returned by
        // FindSubmatchIndex.
        //
        // In the template, a variable is denoted by a substring of the form
        // $name or ${name}, where name is a non-empty sequence of letters,
        // digits, and underscores. A purely numeric name like $1 refers to
        // the submatch with the corresponding index; other names refer to
        // capturing parentheses named with the (?P<name>...) syntax. A
        // reference to an out of range or unmatched index or a name that is not
        // present in the regular expression is replaced with an empty slice.
        //
        // In the $name form, name is taken to be as long as possible: $1x is
        // equivalent to ${1x}, not ${1}x, and, $10 is equivalent to ${10}, not ${1}0.
        //
        // To insert a literal $ in the output, use $$ in the template.
    **/
    @:keep
    static public function expand( _re:Ref<Regexp>, _dst:Slice<GoByte>, _template:Slice<GoByte>, _src:Slice<GoByte>, _match:Slice<GoInt>):Slice<GoByte> {
        return _re._expand(_dst, (_template : GoString), _src, Go.str(), _match);
    }
    /**
        // FindSubmatch returns a slice of slices holding the text of the leftmost
        // match of the regular expression in b and the matches, if any, of its
        // subexpressions, as defined by the 'Submatch' descriptions in the package
        // comment.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findSubmatch( _re:Ref<Regexp>, _b:Slice<GoByte>):Slice<Slice<GoByte>> {
        var _dstCap:GoArray<GoInt> = new GoArray<GoInt>(...[for (i in 0 ... 4) (0 : GoInt)]);
        var _a = _re._doExecute((null : stdgo.io.Io.RuneReader), _b, Go.str(), (0 : GoInt), _re._prog.numCap, (_dstCap.__slice__(0, (0 : GoInt)) : Slice<GoInt>));
        if (_a == null) {
            return (null : Slice<Slice<GoUInt8>>);
        };
        var _ret = new Slice<Slice<GoUInt8>>(((1 : GoInt) + _re._numSubexp : GoInt).toBasic(), 0);
        for (_i in 0 ... _ret.length.toBasic()) {
            if ((((2 : GoInt) * _i) < _a.length) && (_a[((2 : GoInt) * _i : GoInt)] >= (0 : GoInt))) {
                _ret[(_i : GoInt)] = (_b.__slice__(_a[((2 : GoInt) * _i : GoInt)], _a[(((2 : GoInt) * _i) + (1 : GoInt) : GoInt)], _a[(((2 : GoInt) * _i) + (1 : GoInt) : GoInt)]) : Slice<GoUInt8>);
            };
        };
        return _ret;
    }
    /**
        // FindReaderIndex returns a two-element slice of integers defining the
        // location of the leftmost match of the regular expression in text read from
        // the RuneReader. The match text was found in the input stream at
        // byte offset loc[0] through loc[1]-1.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findReaderIndex( _re:Ref<Regexp>, _r:stdgo.io.Io.RuneReader):Slice<GoInt> {
        var _loc:Slice<GoInt> = (null : Slice<GoInt>);
        var _a = _re._doExecute(_r, (null : Slice<GoUInt8>), Go.str(), (0 : GoInt), (2 : GoInt), (null : Slice<GoInt>));
        if (_a == null) {
            return (null : Slice<GoInt>);
        };
        return (_a.__slice__((0 : GoInt), (2 : GoInt)) : Slice<GoInt>);
    }
    /**
        // FindStringIndex returns a two-element slice of integers defining the
        // location of the leftmost match in s of the regular expression. The match
        // itself is at s[loc[0]:loc[1]].
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findStringIndex( _re:Ref<Regexp>, _s:GoString):Slice<GoInt> {
        var _loc:Slice<GoInt> = (null : Slice<GoInt>);
        var _a = _re._doExecute((null : stdgo.io.Io.RuneReader), (null : Slice<GoUInt8>), _s, (0 : GoInt), (2 : GoInt), (null : Slice<GoInt>));
        if (_a == null) {
            return (null : Slice<GoInt>);
        };
        return (_a.__slice__((0 : GoInt), (2 : GoInt)) : Slice<GoInt>);
    }
    /**
        // FindString returns a string holding the text of the leftmost match in s of the regular
        // expression. If there is no match, the return value is an empty string,
        // but it will also be empty if the regular expression successfully matches
        // an empty string. Use FindStringIndex or FindStringSubmatch if it is
        // necessary to distinguish these cases.
    **/
    @:keep
    static public function findString( _re:Ref<Regexp>, _s:GoString):GoString {
        var _dstCap:GoArray<GoInt> = new GoArray<GoInt>(...[for (i in 0 ... 2) (0 : GoInt)]);
        var _a = _re._doExecute((null : stdgo.io.Io.RuneReader), (null : Slice<GoUInt8>), _s, (0 : GoInt), (2 : GoInt), (_dstCap.__slice__(0, (0 : GoInt)) : Slice<GoInt>));
        if (_a == null) {
            return Go.str();
        };
        return (_s.__slice__(_a[(0 : GoInt)], _a[(1 : GoInt)]) : GoString);
    }
    /**
        // FindIndex returns a two-element slice of integers defining the location of
        // the leftmost match in b of the regular expression. The match itself is at
        // b[loc[0]:loc[1]].
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function findIndex( _re:Ref<Regexp>, _b:Slice<GoByte>):Slice<GoInt> {
        var _loc:Slice<GoInt> = (null : Slice<GoInt>);
        var _a = _re._doExecute((null : stdgo.io.Io.RuneReader), _b, Go.str(), (0 : GoInt), (2 : GoInt), (null : Slice<GoInt>));
        if (_a == null) {
            return (null : Slice<GoInt>);
        };
        return (_a.__slice__((0 : GoInt), (2 : GoInt)) : Slice<GoInt>);
    }
    /**
        // Find returns a slice holding the text of the leftmost match in b of the regular expression.
        // A return value of nil indicates no match.
    **/
    @:keep
    static public function find( _re:Ref<Regexp>, _b:Slice<GoByte>):Slice<GoByte> {
        var _dstCap:GoArray<GoInt> = new GoArray<GoInt>(...[for (i in 0 ... 2) (0 : GoInt)]);
        var _a = _re._doExecute((null : stdgo.io.Io.RuneReader), _b, Go.str(), (0 : GoInt), (2 : GoInt), (_dstCap.__slice__(0, (0 : GoInt)) : Slice<GoInt>));
        if (_a == null) {
            return (null : Slice<GoUInt8>);
        };
        return (_b.__slice__(_a[(0 : GoInt)], _a[(1 : GoInt)], _a[(1 : GoInt)]) : Slice<GoUInt8>);
    }
    /**
        // allMatches calls deliver at most n times
        // with the location of successive matches in the input text.
        // The input text is b if non-nil, otherwise s.
    **/
    @:keep
    static public function _allMatches( _re:Ref<Regexp>, _s:GoString, _b:Slice<GoByte>, _n:GoInt, _deliver:Slice<GoInt> -> Void):Void {
        var _end:GoInt = (0 : GoInt);
        if (_b == null) {
            _end = (_s.length);
        } else {
            _end = (_b.length);
        };
        {
            var __0:GoInt = (0 : GoInt), __1:GoInt = (0 : GoInt), __2:GoInt = (-1 : GoInt), _prevMatchEnd:GoInt = __2, _i:GoInt = __1, _pos:GoInt = __0;
            while ((_i < _n) && (_pos <= _end)) {
                var _matches = _re._doExecute((null : stdgo.io.Io.RuneReader), _b, _s, _pos, _re._prog.numCap, (null : Slice<GoInt>));
                if ((_matches.length) == ((0 : GoInt))) {
                    break;
                };
                var _accept:Bool = true;
                if (_matches[(1 : GoInt)] == (_pos)) {
                    if (_matches[(0 : GoInt)] == (_prevMatchEnd)) {
                        _accept = false;
                    };
                    var _width:GoInt = (0 : GoInt);
                    if (_b == null) {
                        var _is:stdgo.regexp.Regexp.T_inputString = ({ _str : _s } : T_inputString);
                        {
                            var __tmp__ = _is._step(_pos);
                            _width = __tmp__._1;
                        };
                    } else {
                        var _ib:stdgo.regexp.Regexp.T_inputBytes = ({ _str : _b } : T_inputBytes);
                        {
                            var __tmp__ = _ib._step(_pos);
                            _width = __tmp__._1;
                        };
                    };
                    if (_width > (0 : GoInt)) {
                        _pos = _pos + (_width);
                    } else {
                        _pos = _end + (1 : GoInt);
                    };
                } else {
                    _pos = _matches[(1 : GoInt)];
                };
                _prevMatchEnd = _matches[(1 : GoInt)];
                if (_accept) {
                    _deliver(_re._pad(_matches));
                    _i++;
                };
            };
        };
    }
    /**
        // The number of capture values in the program may correspond
        // to fewer capturing expressions than are in the regexp.
        // For example, "(a){0}" turns into an empty program, so the
        // maximum capture in the program is 0 but we need to return
        // an expression for \1.  Pad appends -1s to the slice a as needed.
    **/
    @:keep
    static public function _pad( _re:Ref<Regexp>, _a:Slice<GoInt>):Slice<GoInt> {
        if (_a == null) {
            return (null : Slice<GoInt>);
        };
        var _n:GoInt = ((1 : GoInt) + _re._numSubexp) * (2 : GoInt);
        while ((_a.length) < _n) {
            _a = (_a.__append__((-1 : GoInt)));
        };
        return _a;
    }
    /**
        // ReplaceAllFunc returns a copy of src in which all matches of the
        // Regexp have been replaced by the return value of function repl applied
        // to the matched byte slice. The replacement returned by repl is substituted
        // directly, without using Expand.
    **/
    @:keep
    static public function replaceAllFunc( _re:Ref<Regexp>, _src:Slice<GoByte>, _repl:Slice<GoByte> -> Slice<GoByte>):Slice<GoByte> {
        return _re._replaceAll(_src, Go.str(), (2 : GoInt), function(_dst:Slice<GoByte>, _match:Slice<GoInt>):Slice<GoByte> {
            return (_dst.__append__(..._repl((_src.__slice__(_match[(0 : GoInt)], _match[(1 : GoInt)]) : Slice<GoUInt8>)).__toArray__()));
        });
    }
    /**
        // ReplaceAllLiteral returns a copy of src, replacing matches of the Regexp
        // with the replacement bytes repl. The replacement repl is substituted directly,
        // without using Expand.
    **/
    @:keep
    static public function replaceAllLiteral( _re:Ref<Regexp>, _src:Slice<GoByte>, _repl:Slice<GoByte>):Slice<GoByte> {
        return _re._replaceAll(_src, Go.str(), (2 : GoInt), function(_dst:Slice<GoByte>, _match:Slice<GoInt>):Slice<GoByte> {
            return (_dst.__append__(..._repl.__toArray__()));
        });
    }
    /**
        // ReplaceAll returns a copy of src, replacing matches of the Regexp
        // with the replacement text repl. Inside repl, $ signs are interpreted as
        // in Expand, so for instance $1 represents the text of the first submatch.
    **/
    @:keep
    static public function replaceAll( _re:Ref<Regexp>, _src:Slice<GoByte>, _repl:Slice<GoByte>):Slice<GoByte> {
        var _n:GoInt = (2 : GoInt);
        if (stdgo.bytes.Bytes.indexByte(_repl, (36 : GoUInt8)) >= (0 : GoInt)) {
            _n = (2 : GoInt) * (_re._numSubexp + (1 : GoInt));
        };
        var _srepl:GoString = Go.str();
        var _b = _re._replaceAll(_src, Go.str(), _n, function(_dst:Slice<GoByte>, _match:Slice<GoInt>):Slice<GoByte> {
            if ((_srepl.length) != ((_repl.length))) {
                _srepl = (_repl : GoString);
            };
            return _re._expand(_dst, _srepl, _src, Go.str(), _match);
        });
        return _b;
    }
    @:keep
    static public function _replaceAll( _re:Ref<Regexp>, _bsrc:Slice<GoByte>, _src:GoString, _nmatch:GoInt, _repl:(_dst:Slice<GoByte>, _m:Slice<GoInt>) -> Slice<GoByte>):Slice<GoByte> {
        var _lastMatchEnd:GoInt = (0 : GoInt);
        var _searchPos:GoInt = (0 : GoInt);
        var _buf:Slice<GoByte> = (null : Slice<GoUInt8>);
        var _endPos:GoInt = (0 : GoInt);
        if (_bsrc != null) {
            _endPos = (_bsrc.length);
        } else {
            _endPos = (_src.length);
        };
        if (_nmatch > _re._prog.numCap) {
            _nmatch = _re._prog.numCap;
        };
        var _dstCap:GoArray<GoInt> = new GoArray<GoInt>(...[for (i in 0 ... 2) (0 : GoInt)]);
        while (_searchPos <= _endPos) {
            var _a = _re._doExecute((null : stdgo.io.Io.RuneReader), _bsrc, _src, _searchPos, _nmatch, (_dstCap.__slice__(0, (0 : GoInt)) : Slice<GoInt>));
            if ((_a.length) == ((0 : GoInt))) {
                break;
            };
            if (_bsrc != null) {
                _buf = (_buf.__append__(...(_bsrc.__slice__(_lastMatchEnd, _a[(0 : GoInt)]) : Slice<GoUInt8>).__toArray__()));
            } else {
                _buf = (_buf.__append__(...(_src.__slice__(_lastMatchEnd, _a[(0 : GoInt)]) : GoString).__toArray__()));
            };
            if ((_a[(1 : GoInt)] > _lastMatchEnd) || (_a[(0 : GoInt)] == (0 : GoInt))) {
                _buf = _repl(_buf, _a);
            };
            _lastMatchEnd = _a[(1 : GoInt)];
            var _width:GoInt = (0 : GoInt);
            if (_bsrc != null) {
                {
                    var __tmp__ = stdgo.unicode.utf8.Utf8.decodeRune((_bsrc.__slice__(_searchPos) : Slice<GoUInt8>));
                    _width = __tmp__._1;
                };
            } else {
                {
                    var __tmp__ = stdgo.unicode.utf8.Utf8.decodeRuneInString((_src.__slice__(_searchPos) : GoString));
                    _width = __tmp__._1;
                };
            };
            if ((_searchPos + _width) > _a[(1 : GoInt)]) {
                _searchPos = _searchPos + (_width);
            } else if ((_searchPos + (1 : GoInt)) > _a[(1 : GoInt)]) {
                _searchPos++;
            } else {
                _searchPos = _a[(1 : GoInt)];
            };
        };
        if (_bsrc != null) {
            _buf = (_buf.__append__(...(_bsrc.__slice__(_lastMatchEnd) : Slice<GoUInt8>).__toArray__()));
        } else {
            _buf = (_buf.__append__(...(_src.__slice__(_lastMatchEnd) : GoString).__toArray__()));
        };
        return _buf;
    }
    /**
        // ReplaceAllStringFunc returns a copy of src in which all matches of the
        // Regexp have been replaced by the return value of function repl applied
        // to the matched substring. The replacement returned by repl is substituted
        // directly, without using Expand.
    **/
    @:keep
    static public function replaceAllStringFunc( _re:Ref<Regexp>, _src:GoString, _repl:GoString -> GoString):GoString {
        var _b = _re._replaceAll((null : Slice<GoUInt8>), _src, (2 : GoInt), function(_dst:Slice<GoByte>, _match:Slice<GoInt>):Slice<GoByte> {
            return (_dst.__append__(..._repl((_src.__slice__(_match[(0 : GoInt)], _match[(1 : GoInt)]) : GoString)).__toArray__()));
        });
        return (_b : GoString);
    }
    /**
        // ReplaceAllLiteralString returns a copy of src, replacing matches of the Regexp
        // with the replacement string repl. The replacement repl is substituted directly,
        // without using Expand.
    **/
    @:keep
    static public function replaceAllLiteralString( _re:Ref<Regexp>, _src:GoString, _repl:GoString):GoString {
        return (_re._replaceAll((null : Slice<GoUInt8>), _src, (2 : GoInt), function(_dst:Slice<GoByte>, _match:Slice<GoInt>):Slice<GoByte> {
            return (_dst.__append__(..._repl.__toArray__()));
        }) : GoString);
    }
    /**
        // ReplaceAllString returns a copy of src, replacing matches of the Regexp
        // with the replacement string repl. Inside repl, $ signs are interpreted as
        // in Expand, so for instance $1 represents the text of the first submatch.
    **/
    @:keep
    static public function replaceAllString( _re:Ref<Regexp>, _src:GoString, _repl:GoString):GoString {
        var _n:GoInt = (2 : GoInt);
        if (stdgo.strings.Strings.contains(_repl, ("$$" : GoString))) {
            _n = (2 : GoInt) * (_re._numSubexp + (1 : GoInt));
        };
        var _b = _re._replaceAll((null : Slice<GoUInt8>), _src, _n, function(_dst:Slice<GoByte>, _match:Slice<GoInt>):Slice<GoByte> {
            return _re._expand(_dst, _repl, (null : Slice<GoUInt8>), _src, _match);
        });
        return (_b : GoString);
    }
    /**
        // Match reports whether the byte slice b
        // contains any match of the regular expression re.
    **/
    @:keep
    static public function match( _re:Ref<Regexp>, _b:Slice<GoByte>):Bool {
        return _re._doMatch((null : stdgo.io.Io.RuneReader), _b, Go.str());
    }
    /**
        // MatchString reports whether the string s
        // contains any match of the regular expression re.
    **/
    @:keep
    static public function matchString( _re:Ref<Regexp>, _s:GoString):Bool {
        return _re._doMatch((null : stdgo.io.Io.RuneReader), (null : Slice<GoUInt8>), _s);
    }
    /**
        // MatchReader reports whether the text returned by the RuneReader
        // contains any match of the regular expression re.
    **/
    @:keep
    static public function matchReader( _re:Ref<Regexp>, _r:stdgo.io.Io.RuneReader):Bool {
        return _re._doMatch(_r, (null : Slice<GoUInt8>), Go.str());
    }
    /**
        // LiteralPrefix returns a literal string that must begin any match
        // of the regular expression re. It returns the boolean true if the
        // literal string comprises the entire regular expression.
    **/
    @:keep
    static public function literalPrefix( _re:Ref<Regexp>):{ var _0 : GoString; var _1 : Bool; } {
        var _prefix:GoString = ("" : GoString), _complete:Bool = false;
        return { _0 : _re._prefix, _1 : _re._prefixComplete };
    }
    /**
        // SubexpIndex returns the index of the first subexpression with the given name,
        // or -1 if there is no subexpression with that name.
        //
        // Note that multiple subexpressions can be written using the same name, as in
        // (?P<bob>a+)(?P<bob>b+), which declares two subexpressions named "bob".
        // In this case, SubexpIndex returns the index of the leftmost such subexpression
        // in the regular expression.
    **/
    @:keep
    static public function subexpIndex( _re:Ref<Regexp>, _name:GoString):GoInt {
        if (_name != (Go.str())) {
            for (_i => _s in _re._subexpNames) {
                if (_name == (_s)) {
                    return _i;
                };
            };
        };
        return (-1 : GoInt);
    }
    /**
        // SubexpNames returns the names of the parenthesized subexpressions
        // in this Regexp. The name for the first sub-expression is names[1],
        // so that if m is a match slice, the name for m[i] is SubexpNames()[i].
        // Since the Regexp as a whole cannot be named, names[0] is always
        // the empty string. The slice should not be modified.
    **/
    @:keep
    static public function subexpNames( _re:Ref<Regexp>):Slice<GoString> {
        return _re._subexpNames;
    }
    /**
        // NumSubexp returns the number of parenthesized subexpressions in this Regexp.
    **/
    @:keep
    static public function numSubexp( _re:Ref<Regexp>):GoInt {
        return _re._numSubexp;
    }
    /**
        // put returns a machine to the correct machine pool.
    **/
    @:keep
    static public function _put( _re:Ref<Regexp>, _m:Ref<T_machine>):Void {
        _m._re = null;
        _m._p = null;
        _m._inputs._clear();
        _matchPool[(_re._mpool : GoInt)].put(Go.toInterface(Go.asInterface(_m)));
    }
    /**
        // get returns a machine to use for matching re.
        // It uses the re's machine cache if possible, to avoid
        // unnecessary allocation.
    **/
    @:keep
    static public function _get( _re:Ref<Regexp>):Ref<T_machine> {
        var __tmp__ = try {
            { value : (Go.typeAssert((_matchPool[(_re._mpool : GoInt)].get() : Ref<T_machine>)) : Ref<T_machine>), ok : true };
        } catch(_) {
            { value : (null : Ref<stdgo.regexp.Regexp.T_machine>), ok : false };
        }, _m = __tmp__.value, _ok = __tmp__.ok;
        if (!_ok) {
            _m = (Go.setRef(({} : stdgo.regexp.Regexp.T_machine)) : Ref<stdgo.regexp.Regexp.T_machine>);
        };
        _m._re = _re;
        _m._p = _re._prog;
        if (_m._matchcap.capacity < _re._matchcap) {
            _m._matchcap = new Slice<GoInt>((_re._matchcap : GoInt).toBasic(), 0).__setNumber32__();
            for (__0 => _t in _m._pool) {
                _t._cap = new Slice<GoInt>((_re._matchcap : GoInt).toBasic(), 0).__setNumber32__();
            };
        };
        var _n:GoInt = _matchSize[(_re._mpool : GoInt)];
        if (_n == ((0 : GoInt))) {
            _n = (_re._prog.inst.length);
        };
        if ((_m._q0._sparse.length) < _n) {
            _m._q0 = (new T_queue(new Slice<GoUInt32>((_n : GoInt).toBasic(), 0).__setNumber32__(), new Slice<stdgo.regexp.Regexp.T_entry>((0 : GoInt).toBasic(), _n)) : T_queue);
            _m._q1 = (new T_queue(new Slice<GoUInt32>((_n : GoInt).toBasic(), 0).__setNumber32__(), new Slice<stdgo.regexp.Regexp.T_entry>((0 : GoInt).toBasic(), _n)) : T_queue);
        };
        return _m;
    }
    /**
        // Longest makes future searches prefer the leftmost-longest match.
        // That is, when matching against text, the regexp returns a match that
        // begins as early as possible in the input (leftmost), and among those
        // it chooses a match that is as long as possible.
        // This method modifies the Regexp and may not be called concurrently
        // with any other methods.
    **/
    @:keep
    static public function longest( _re:Ref<Regexp>):Void {
        _re._longest = true;
    }
    /**
        // Copy returns a new Regexp object copied from re.
        // Calling Longest on one copy does not affect another.
        //
        // Deprecated: In earlier releases, when using a Regexp in multiple goroutines,
        // giving each goroutine its own copy helped to avoid lock contention.
        // As of Go 1.12, using Copy is no longer necessary to avoid lock contention.
        // Copy may still be appropriate if the reason for its use is to make
        // two copies with different Longest settings.
    **/
    @:keep
    static public function copy( _re:Ref<Regexp>):Ref<Regexp> {
        var _re2:stdgo.regexp.Regexp.Regexp = (_re : stdgo.regexp.Regexp.Regexp)?.__copy__();
        return (Go.setRef(_re2) : Ref<stdgo.regexp.Regexp.Regexp>);
    }
    /**
        // String returns the source text used to compile the regular expression.
    **/
    @:keep
    static public function string( _re:Ref<Regexp>):GoString {
        return _re._expr;
    }
    /**
        // doExecute finds the leftmost match in the input, appends the position
        // of its subexpressions to dstCap and returns dstCap.
        //
        // nil is returned if no matches are found and non-nil if matches are found.
    **/
    @:keep
    static public function _doExecute( _re:Ref<Regexp>, _r:stdgo.io.Io.RuneReader, _b:Slice<GoByte>, _s:GoString, _pos:GoInt, _ncap:GoInt, _dstCap:Slice<GoInt>):Slice<GoInt> {
        if (_dstCap == null) {
            _dstCap = (_arrayNoInts.__slice__(0, (0 : GoInt), (0 : GoInt)) : Slice<GoInt>);
        };
        if ((_r == null) && ((_b.length + _s.length) < _re._minInputLen)) {
            return (null : Slice<GoInt>);
        };
        if (_re._onepass != null && ((_re._onepass : Dynamic).__nil__ == null || !(_re._onepass : Dynamic).__nil__)) {
            return _re._doOnePass(_r, _b, _s, _pos, _ncap, _dstCap);
        };
        if ((_r == null) && ((_b.length + _s.length) < _re._maxBitStateLen)) {
            return _re._backtrack(_b, _s, _pos, _ncap, _dstCap);
        };
        var _m = _re._get();
        var __tmp__ = _m._inputs._init(_r, _b, _s), _i:stdgo.regexp.Regexp.T_input = __tmp__._0, __0:GoInt = __tmp__._1;
        _m._init(_ncap);
        if (!_m._match(_i, _pos)) {
            _re._put(_m);
            return (null : Slice<GoInt>);
        };
        _dstCap = (_dstCap.__append__(..._m._matchcap.__toArray__()));
        _re._put(_m);
        return _dstCap;
    }
    /**
        // doMatch reports whether either r, b or s match the regexp.
    **/
    @:keep
    static public function _doMatch( _re:Ref<Regexp>, _r:stdgo.io.Io.RuneReader, _b:Slice<GoByte>, _s:GoString):Bool {
        return _re._doExecute(_r, _b, _s, (0 : GoInt), (0 : GoInt), (null : Slice<GoInt>)) != null;
    }
    /**
        // doOnePass implements r.doExecute using the one-pass execution engine.
    **/
    @:keep
    static public function _doOnePass( _re:Ref<Regexp>, _ir:stdgo.io.Io.RuneReader, _ib:Slice<GoByte>, _is:GoString, _pos:GoInt, _ncap:GoInt, _dstCap:Slice<GoInt>):Slice<GoInt> {
        stdgo.internal.Macro.controlFlow({
            var _startCond:stdgo.regexp.syntax.Syntax.EmptyOp = _re._cond;
            if (_startCond == ((255 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
                return (null : Slice<GoInt>);
            };
            var _m = _newOnePassMachine();
            if (_m._matchcap.capacity < _ncap) {
                _m._matchcap = new Slice<GoInt>((_ncap : GoInt).toBasic(), 0).__setNumber32__();
            } else {
                _m._matchcap = (_m._matchcap.__slice__(0, _ncap) : Slice<GoInt>);
            };
            var _matched:Bool = false;
            for (_i in 0 ... _m._matchcap.length.toBasic()) {
                _m._matchcap[(_i : GoInt)] = (-1 : GoInt);
            };
            var __tmp__ = _m._inputs._init(_ir, _ib, _is), _i:stdgo.regexp.Regexp.T_input = __tmp__._0, __0:GoInt = __tmp__._1;
            var __0:GoInt32 = (-1 : GoInt32), __1:GoInt32 = (-1 : GoInt32), _r1:GoInt32 = __1, _r:GoInt32 = __0;
            var __0:GoInt = (0 : GoInt), __1:GoInt = (0 : GoInt), _width1:GoInt = __1, _width:GoInt = __0;
            {
                var __tmp__ = _i._step(_pos);
                _r = __tmp__._0;
                _width = __tmp__._1;
            };
            if (_r != ((-1 : GoInt32))) {
                {
                    var __tmp__ = _i._step(_pos + _width);
                    _r1 = __tmp__._0;
                    _width1 = __tmp__._1;
                };
            };
            var _flag:T_lazyFlag = ((0 : GoUInt64) : stdgo.regexp.Regexp.T_lazyFlag);
            if (_pos == ((0 : GoInt))) {
                _flag = _newLazyFlag((-1 : GoInt32), _r);
            } else {
                _flag = _i._context(_pos);
            };
            var _pc:GoInt = _re._onepass.start;
            var _inst = (Go.setRef(_re._onepass.inst[(_pc : GoInt)]) : Ref<stdgo.regexp.Regexp.T_onePassInst>);
            if ((((_pos == (0 : GoInt)) && _flag._match((_inst.inst.arg : stdgo.regexp.syntax.Syntax.EmptyOp))) && (_re._prefix.length > (0 : GoInt))) && _i._canCheckPrefix()) {
                if (!_i._hasPrefix(_re)) {
                    @:goto "Return";
                };
                _pos = _pos + ((_re._prefix.length));
                {
                    var __tmp__ = _i._step(_pos);
                    _r = __tmp__._0;
                    _width = __tmp__._1;
                };
                {
                    var __tmp__ = _i._step(_pos + _width);
                    _r1 = __tmp__._0;
                    _width1 = __tmp__._1;
                };
                _flag = _i._context(_pos);
                _pc = (_re._prefixEnd : GoInt);
            };
            while (true) {
                _inst = (Go.setRef(_re._onepass.inst[(_pc : GoInt)]) : Ref<stdgo.regexp.Regexp.T_onePassInst>);
                _pc = (_inst.inst.out : GoInt);
                {
                    final __value__ = _inst.inst.op;
                    if (__value__ == ((4 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        _matched = true;
                        if ((_m._matchcap.length) > (0 : GoInt)) {
                            _m._matchcap[(0 : GoInt)] = (0 : GoInt);
                            _m._matchcap[(1 : GoInt)] = _pos;
                        };
                        @:goto "Return";
                    } else if (__value__ == ((7 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if (!_inst.matchRune(_r)) {
                            @:goto "Return";
                        };
                    } else if (__value__ == ((8 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if (_r != (_inst.inst.rune[((0 : GoInt) : GoInt)])) {
                            @:goto "Return";
                        };
                    } else if (__value__ == ((9 : stdgo.regexp.syntax.Syntax.InstOp))) {} else if (__value__ == ((10 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if (_r == ((10 : GoInt32))) {
                            @:goto "Return";
                        };
                    } else if (__value__ == ((0 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((1 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        _pc = (_onePassNext(_inst, _r) : GoInt);
                        continue;
                    } else if (__value__ == ((5 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        @:goto "Return";
                    } else if (__value__ == ((6 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        continue;
                    } else if (__value__ == ((3 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if (!_flag._match((_inst.inst.arg : stdgo.regexp.syntax.Syntax.EmptyOp))) {
                            @:goto "Return";
                        };
                        continue;
                    } else if (__value__ == ((2 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if ((_inst.inst.arg : GoInt) < (_m._matchcap.length)) {
                            _m._matchcap[(_inst.inst.arg : GoInt)] = _pos;
                        };
                        continue;
                    } else {
                        throw Go.toInterface(("bad inst" : GoString));
                    };
                };
                if (_width == ((0 : GoInt))) {
                    break;
                };
                _flag = _newLazyFlag(_r, _r1);
                _pos = _pos + (_width);
                {
                    final __tmp__0 = _r1;
                    final __tmp__1 = _width1;
                    _r = __tmp__0;
                    _width = __tmp__1;
                };
                if (_r != ((-1 : GoInt32))) {
                    {
                        var __tmp__ = _i._step(_pos + _width);
                        _r1 = __tmp__._0;
                        _width1 = __tmp__._1;
                    };
                };
            };
            @:label("Return") if (!_matched) {
                _freeOnePassMachine(_m);
                return (null : Slice<GoInt>);
            };
            _dstCap = (_dstCap.__append__(..._m._matchcap.__toArray__()));
            _freeOnePassMachine(_m);
            return _dstCap;
        });
        throw "controlFlow did not return";
    }
    /**
        // backtrack runs a backtracking search of prog on the input starting at pos.
    **/
    @:keep
    static public function _backtrack( _re:Ref<Regexp>, _ib:Slice<GoByte>, _is:GoString, _pos:GoInt, _ncap:GoInt, _dstCap:Slice<GoInt>):Slice<GoInt> {
        stdgo.internal.Macro.controlFlow({
            var _startCond:stdgo.regexp.syntax.Syntax.EmptyOp = _re._cond;
            if (_startCond == ((255 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
                return (null : Slice<GoInt>);
            };
            if (((_startCond & (4 : stdgo.regexp.syntax.Syntax.EmptyOp)) != (0 : stdgo.regexp.syntax.Syntax.EmptyOp)) && (_pos != (0 : GoInt))) {
                return (null : Slice<GoInt>);
            };
            var _b = _newBitState();
            var __tmp__ = _b._inputs._init((null : stdgo.io.Io.RuneReader), _ib, _is), _i:stdgo.regexp.Regexp.T_input = __tmp__._0, _end:GoInt = __tmp__._1;
            _b._reset(_re._prog, _end, _ncap);
            if (_startCond & (4 : stdgo.regexp.syntax.Syntax.EmptyOp) != ((0 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
                if ((_b._cap.length) > (0 : GoInt)) {
                    _b._cap[(0 : GoInt)] = _pos;
                };
                if (!_re._tryBacktrack(_b, _i, (_re._prog.start : GoUInt32), _pos)) {
                    _freeBitState(_b);
                    return (null : Slice<GoInt>);
                };
            } else {
                var _width:GoInt = (-1 : GoInt);
                Go.cfor((_pos <= _end) && (_width != (0 : GoInt)), _pos = _pos + (_width), {
                    if ((_re._prefix.length) > (0 : GoInt)) {
                        var _advance:GoInt = _i._index(_re, _pos);
                        if (_advance < (0 : GoInt)) {
                            _freeBitState(_b);
                            return (null : Slice<GoInt>);
                        };
                        _pos = _pos + (_advance);
                    };
                    if ((_b._cap.length) > (0 : GoInt)) {
                        _b._cap[(0 : GoInt)] = _pos;
                    };
                    if (_re._tryBacktrack(_b, _i, (_re._prog.start : GoUInt32), _pos)) {
                        @:goto "Match";
                    };
                    {
                        var __tmp__ = _i._step(_pos);
                        _width = __tmp__._1;
                    };
                });
                _freeBitState(_b);
                return (null : Slice<GoInt>);
            };
            @:label("Match") _dstCap = (_dstCap.__append__(..._b._matchcap.__toArray__()));
            _freeBitState(_b);
            return _dstCap;
        });
        throw "controlFlow did not return";
    }
    /**
        // tryBacktrack runs a backtracking search starting at pos.
    **/
    @:keep
    static public function _tryBacktrack( _re:Ref<Regexp>, _b:Ref<T_bitState>, _i:T_input, _pc:GoUInt32, _pos:GoInt):Bool {
        stdgo.internal.Macro.controlFlow({
            var _longest:Bool = _re._longest;
            _b._push(_re, _pc, _pos, false);
            while ((_b._jobs.length) > (0 : GoInt)) {
                var _l:GoInt = (_b._jobs.length) - (1 : GoInt);
                var _pc:GoUInt32 = _b._jobs[(_l : GoInt)]._pc;
                var _pos:GoInt = _b._jobs[(_l : GoInt)]._pos;
                var _arg:Bool = _b._jobs[(_l : GoInt)]._arg;
                _b._jobs = (_b._jobs.__slice__(0, _l) : Slice<stdgo.regexp.Regexp.T_job>);
                @:goto "Skip";
                @:label("CheckAndLoop") if (!_b._shouldVisit(_pc, _pos)) {
                    continue;
                };
                @:label("Skip") var _inst = (Go.setRef(_re._prog.inst[(_pc : GoInt)]) : Ref<stdgo.regexp.syntax.Syntax.Inst>);
                {
                    final __value__ = _inst.op;
                    if (__value__ == ((5 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        throw Go.toInterface(("unexpected InstFail" : GoString));
                    } else if (__value__ == ((0 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if (_arg) {
                            _arg = false;
                            _pc = _inst.arg;
                            @:goto "CheckAndLoop";
                        } else {
                            _b._push(_re, _pc, _pos, true);
                            _pc = _inst.out;
                            @:goto "CheckAndLoop";
                        };
                    } else if (__value__ == ((1 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        {
                            final __value__ = _re._prog.inst[(_inst.out : GoInt)].op;
                            if (__value__ == ((7 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((8 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((9 : stdgo.regexp.syntax.Syntax.InstOp)) || __value__ == ((10 : stdgo.regexp.syntax.Syntax.InstOp))) {
                                _b._push(_re, _inst.arg, _pos, false);
                                _pc = _inst.arg;
                                _pos = _b._end;
                                @:goto "CheckAndLoop";
                            };
                        };
                        _b._push(_re, _inst.out, _b._end, false);
                        _pc = _inst.out;
                        @:goto "CheckAndLoop";
                    } else if (__value__ == ((7 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        var __tmp__ = _i._step(_pos), _r:GoInt32 = __tmp__._0, _width:GoInt = __tmp__._1;
                        if (!_inst.matchRune(_r)) {
                            continue;
                        };
                        _pos = _pos + (_width);
                        _pc = _inst.out;
                        @:goto "CheckAndLoop";
                    } else if (__value__ == ((8 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        var __tmp__ = _i._step(_pos), _r:GoInt32 = __tmp__._0, _width:GoInt = __tmp__._1;
                        if (_r != (_inst.rune[((0 : GoInt) : GoInt)])) {
                            continue;
                        };
                        _pos = _pos + (_width);
                        _pc = _inst.out;
                        @:goto "CheckAndLoop";
                    } else if (__value__ == ((10 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        var __tmp__ = _i._step(_pos), _r:GoInt32 = __tmp__._0, _width:GoInt = __tmp__._1;
                        if ((_r == (10 : GoInt32)) || (_r == (-1 : GoInt32))) {
                            continue;
                        };
                        _pos = _pos + (_width);
                        _pc = _inst.out;
                        @:goto "CheckAndLoop";
                    } else if (__value__ == ((9 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        var __tmp__ = _i._step(_pos), _r:GoInt32 = __tmp__._0, _width:GoInt = __tmp__._1;
                        if (_r == ((-1 : GoInt32))) {
                            continue;
                        };
                        _pos = _pos + (_width);
                        _pc = _inst.out;
                        @:goto "CheckAndLoop";
                    } else if (__value__ == ((2 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if (_arg) {
                            _b._cap[(_inst.arg : GoInt)] = _pos;
                            continue;
                        } else {
                            if (_inst.arg < (_b._cap.length : GoUInt32)) {
                                _b._push(_re, _pc, _b._cap[(_inst.arg : GoInt)], true);
                                _b._cap[(_inst.arg : GoInt)] = _pos;
                            };
                            _pc = _inst.out;
                            @:goto "CheckAndLoop";
                        };
                    } else if (__value__ == ((3 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        var _flag:stdgo.regexp.Regexp.T_lazyFlag = _i._context(_pos);
                        if (!_flag._match((_inst.arg : stdgo.regexp.syntax.Syntax.EmptyOp))) {
                            continue;
                        };
                        _pc = _inst.out;
                        @:goto "CheckAndLoop";
                    } else if (__value__ == ((6 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        _pc = _inst.out;
                        @:goto "CheckAndLoop";
                    } else if (__value__ == ((4 : stdgo.regexp.syntax.Syntax.InstOp))) {
                        if ((_b._cap.length) == ((0 : GoInt))) {
                            return true;
                        };
                        if ((_b._cap.length) > (1 : GoInt)) {
                            _b._cap[(1 : GoInt)] = _pos;
                        };
                        {
                            var _old:GoInt = _b._matchcap[(1 : GoInt)];
                            if ((_old == (-1 : GoInt)) || ((_longest && (_pos > (0 : GoInt))) && (_pos > _old))) {
                                Go.copySlice(_b._matchcap, _b._cap);
                            };
                        };
                        if (!_longest) {
                            return true;
                        };
                        if (_pos == (_b._end)) {
                            return true;
                        };
                        continue;
                    } else {
                        throw Go.toInterface(("bad inst" : GoString));
                    };
                };
            };
            return (_longest && (_b._matchcap.length > (1 : GoInt))) && (_b._matchcap[(1 : GoInt)] >= (0 : GoInt));
        });
        throw "controlFlow did not return";
    }
}
class T_inputString_asInterface {
    @:keep
    public dynamic function _context(_pos:GoInt):T_lazyFlag return __self__.value._context(_pos);
    @:keep
    public dynamic function _index(_re:Ref<Regexp>, _pos:GoInt):GoInt return __self__.value._index(_re, _pos);
    @:keep
    public dynamic function _hasPrefix(_re:Ref<Regexp>):Bool return __self__.value._hasPrefix(_re);
    @:keep
    public dynamic function _canCheckPrefix():Bool return __self__.value._canCheckPrefix();
    @:keep
    public dynamic function _step(_pos:GoInt):{ var _0 : GoRune; var _1 : GoInt; } return __self__.value._step(_pos);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_inputString>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_inputString_asInterface) class T_inputString_static_extension {
    @:keep
    static public function _context( _i:Ref<T_inputString>, _pos:GoInt):T_lazyFlag {
        var __0:GoInt32 = (-1 : GoInt32), __1:GoInt32 = (-1 : GoInt32), _r2:GoInt32 = __1, _r1:GoInt32 = __0;
        if ((_pos - (1 : GoInt) : GoUInt) < (_i._str.length : GoUInt)) {
            _r1 = (_i._str[(_pos - (1 : GoInt) : GoInt)] : GoRune);
            if (_r1 >= (128 : GoInt32)) {
                {
                    var __tmp__ = stdgo.unicode.utf8.Utf8.decodeLastRuneInString((_i._str.__slice__(0, _pos) : GoString));
                    _r1 = __tmp__._0;
                };
            };
        };
        if ((_pos : GoUInt) < (_i._str.length : GoUInt)) {
            _r2 = (_i._str[(_pos : GoInt)] : GoRune);
            if (_r2 >= (128 : GoInt32)) {
                {
                    var __tmp__ = stdgo.unicode.utf8.Utf8.decodeRuneInString((_i._str.__slice__(_pos) : GoString));
                    _r2 = __tmp__._0;
                };
            };
        };
        return _newLazyFlag(_r1, _r2);
    }
    @:keep
    static public function _index( _i:Ref<T_inputString>, _re:Ref<Regexp>, _pos:GoInt):GoInt {
        return stdgo.strings.Strings.index((_i._str.__slice__(_pos) : GoString), _re._prefix);
    }
    @:keep
    static public function _hasPrefix( _i:Ref<T_inputString>, _re:Ref<Regexp>):Bool {
        return stdgo.strings.Strings.hasPrefix(_i._str, _re._prefix);
    }
    @:keep
    static public function _canCheckPrefix( _i:Ref<T_inputString>):Bool {
        return true;
    }
    @:keep
    static public function _step( _i:Ref<T_inputString>, _pos:GoInt):{ var _0 : GoRune; var _1 : GoInt; } {
        if (_pos < (_i._str.length)) {
            var _c:GoUInt8 = _i._str[(_pos : GoInt)];
            if (_c < (128 : GoUInt8)) {
                return { _0 : (_c : GoRune), _1 : (1 : GoInt) };
            };
            return stdgo.unicode.utf8.Utf8.decodeRuneInString((_i._str.__slice__(_pos) : GoString));
        };
        return { _0 : (-1 : GoInt32), _1 : (0 : GoInt) };
    }
}
class T_inputBytes_asInterface {
    @:keep
    public dynamic function _context(_pos:GoInt):T_lazyFlag return __self__.value._context(_pos);
    @:keep
    public dynamic function _index(_re:Ref<Regexp>, _pos:GoInt):GoInt return __self__.value._index(_re, _pos);
    @:keep
    public dynamic function _hasPrefix(_re:Ref<Regexp>):Bool return __self__.value._hasPrefix(_re);
    @:keep
    public dynamic function _canCheckPrefix():Bool return __self__.value._canCheckPrefix();
    @:keep
    public dynamic function _step(_pos:GoInt):{ var _0 : GoRune; var _1 : GoInt; } return __self__.value._step(_pos);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_inputBytes>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_inputBytes_asInterface) class T_inputBytes_static_extension {
    @:keep
    static public function _context( _i:Ref<T_inputBytes>, _pos:GoInt):T_lazyFlag {
        var __0:GoInt32 = (-1 : GoInt32), __1:GoInt32 = (-1 : GoInt32), _r2:GoInt32 = __1, _r1:GoInt32 = __0;
        if ((_pos - (1 : GoInt) : GoUInt) < (_i._str.length : GoUInt)) {
            _r1 = (_i._str[(_pos - (1 : GoInt) : GoInt)] : GoRune);
            if (_r1 >= (128 : GoInt32)) {
                {
                    var __tmp__ = stdgo.unicode.utf8.Utf8.decodeLastRune((_i._str.__slice__(0, _pos) : Slice<GoUInt8>));
                    _r1 = __tmp__._0;
                };
            };
        };
        if ((_pos : GoUInt) < (_i._str.length : GoUInt)) {
            _r2 = (_i._str[(_pos : GoInt)] : GoRune);
            if (_r2 >= (128 : GoInt32)) {
                {
                    var __tmp__ = stdgo.unicode.utf8.Utf8.decodeRune((_i._str.__slice__(_pos) : Slice<GoUInt8>));
                    _r2 = __tmp__._0;
                };
            };
        };
        return _newLazyFlag(_r1, _r2);
    }
    @:keep
    static public function _index( _i:Ref<T_inputBytes>, _re:Ref<Regexp>, _pos:GoInt):GoInt {
        return stdgo.bytes.Bytes.index((_i._str.__slice__(_pos) : Slice<GoUInt8>), _re._prefixBytes);
    }
    @:keep
    static public function _hasPrefix( _i:Ref<T_inputBytes>, _re:Ref<Regexp>):Bool {
        return stdgo.bytes.Bytes.hasPrefix(_i._str, _re._prefixBytes);
    }
    @:keep
    static public function _canCheckPrefix( _i:Ref<T_inputBytes>):Bool {
        return true;
    }
    @:keep
    static public function _step( _i:Ref<T_inputBytes>, _pos:GoInt):{ var _0 : GoRune; var _1 : GoInt; } {
        if (_pos < (_i._str.length)) {
            var _c:GoUInt8 = _i._str[(_pos : GoInt)];
            if (_c < (128 : GoUInt8)) {
                return { _0 : (_c : GoRune), _1 : (1 : GoInt) };
            };
            return stdgo.unicode.utf8.Utf8.decodeRune((_i._str.__slice__(_pos) : Slice<GoUInt8>));
        };
        return { _0 : (-1 : GoInt32), _1 : (0 : GoInt) };
    }
}
class T_inputReader_asInterface {
    @:keep
    public dynamic function _context(_pos:GoInt):T_lazyFlag return __self__.value._context(_pos);
    @:keep
    public dynamic function _index(_re:Ref<Regexp>, _pos:GoInt):GoInt return __self__.value._index(_re, _pos);
    @:keep
    public dynamic function _hasPrefix(_re:Ref<Regexp>):Bool return __self__.value._hasPrefix(_re);
    @:keep
    public dynamic function _canCheckPrefix():Bool return __self__.value._canCheckPrefix();
    @:keep
    public dynamic function _step(_pos:GoInt):{ var _0 : GoRune; var _1 : GoInt; } return __self__.value._step(_pos);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_inputReader>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_inputReader_asInterface) class T_inputReader_static_extension {
    @:keep
    static public function _context( _i:Ref<T_inputReader>, _pos:GoInt):T_lazyFlag {
        return (0i64 : stdgo.regexp.Regexp.T_lazyFlag);
    }
    @:keep
    static public function _index( _i:Ref<T_inputReader>, _re:Ref<Regexp>, _pos:GoInt):GoInt {
        return (-1 : GoInt);
    }
    @:keep
    static public function _hasPrefix( _i:Ref<T_inputReader>, _re:Ref<Regexp>):Bool {
        return false;
    }
    @:keep
    static public function _canCheckPrefix( _i:Ref<T_inputReader>):Bool {
        return false;
    }
    @:keep
    static public function _step( _i:Ref<T_inputReader>, _pos:GoInt):{ var _0 : GoRune; var _1 : GoInt; } {
        if (!_i._atEOT && (_pos != _i._pos)) {
            return { _0 : (-1 : GoInt32), _1 : (0 : GoInt) };
        };
        var __tmp__ = _i._r.readRune(), _r:GoInt32 = __tmp__._0, _w:GoInt = __tmp__._1, _err:Error = __tmp__._2;
        if (_err != null) {
            _i._atEOT = true;
            return { _0 : (-1 : GoInt32), _1 : (0 : GoInt) };
        };
        _i._pos = _i._pos + (_w);
        return { _0 : _r, _1 : _w };
    }
}
class T_lazyFlag_asInterface {
    @:keep
    public dynamic function _match(_op:stdgo.regexp.syntax.Syntax.EmptyOp):Bool return __self__.value._match(_op);
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_lazyFlag>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_lazyFlag_asInterface) class T_lazyFlag_static_extension {
    @:keep
    static public function _match( _f:T_lazyFlag, _op:stdgo.regexp.syntax.Syntax.EmptyOp):Bool {
        if (_op == ((0 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            return true;
        };
        var _r1:GoInt32 = (_f >> (32i64 : GoUInt64) : GoRune);
        if (_op & (1 : stdgo.regexp.syntax.Syntax.EmptyOp) != ((0 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            if ((_r1 != (10 : GoInt32)) && (_r1 >= (0 : GoInt32))) {
                return false;
            };
            _op = _op & ((1 : stdgo.regexp.syntax.Syntax.EmptyOp) ^ (-1i32 : GoInt));
        };
        if (_op & (4 : stdgo.regexp.syntax.Syntax.EmptyOp) != ((0 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            if (_r1 >= (0 : GoInt32)) {
                return false;
            };
            _op = _op & ((4 : stdgo.regexp.syntax.Syntax.EmptyOp) ^ (-1i32 : GoInt));
        };
        if (_op == ((0 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            return true;
        };
        var _r2:GoInt32 = (_f : GoRune);
        if (_op & (2 : stdgo.regexp.syntax.Syntax.EmptyOp) != ((0 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            if ((_r2 != (10 : GoInt32)) && (_r2 >= (0 : GoInt32))) {
                return false;
            };
            _op = _op & ((2 : stdgo.regexp.syntax.Syntax.EmptyOp) ^ (-1i32 : GoInt));
        };
        if (_op & (8 : stdgo.regexp.syntax.Syntax.EmptyOp) != ((0 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            if (_r2 >= (0 : GoInt32)) {
                return false;
            };
            _op = _op & ((8 : stdgo.regexp.syntax.Syntax.EmptyOp) ^ (-1i32 : GoInt));
        };
        if (_op == ((0 : stdgo.regexp.syntax.Syntax.EmptyOp))) {
            return true;
        };
        if (stdgo.regexp.syntax.Syntax.isWordChar(_r1) != (stdgo.regexp.syntax.Syntax.isWordChar(_r2))) {
            _op = _op & ((16 : stdgo.regexp.syntax.Syntax.EmptyOp) ^ (-1i32 : GoInt));
        } else {
            _op = _op & ((32 : stdgo.regexp.syntax.Syntax.EmptyOp) ^ (-1i32 : GoInt));
        };
        return _op == ((0 : stdgo.regexp.syntax.Syntax.EmptyOp));
    }
}
class T_runeSlice_asInterface {
    @:keep
    public dynamic function swap(_i:GoInt, _j:GoInt):Void __self__.value.swap(_i, _j);
    @:keep
    public dynamic function less(_i:GoInt, _j:GoInt):Bool return __self__.value.less(_i, _j);
    @:keep
    public dynamic function len():GoInt return __self__.value.len();
    public function new(__self__, __type__) {
        this.__self__ = __self__;
        this.__type__ = __type__;
    }
    public function __underlying__() return new AnyInterface((__type__.kind() == stdgo.internal.reflect.Reflect.KindType.pointer && !stdgo.internal.reflect.Reflect.isReflectTypeRef(__type__)) ? (__self__ : Dynamic) : (__self__.value : Dynamic), __type__);
    var __self__ : Pointer<T_runeSlice>;
    var __type__ : stdgo.internal.reflect.Reflect._Type;
}
@:keep @:allow(stdgo.regexp.Regexp.T_runeSlice_asInterface) class T_runeSlice_static_extension {
    @:keep
    static public function swap( _p:T_runeSlice, _i:GoInt, _j:GoInt):Void {
        {
            final __tmp__0 = _p[(_j : GoInt)];
            final __tmp__1 = _p[(_i : GoInt)];
            _p[(_i : GoInt)] = __tmp__0;
            _p[(_j : GoInt)] = __tmp__1;
        };
    }
    @:keep
    static public function less( _p:T_runeSlice, _i:GoInt, _j:GoInt):Bool {
        return _p[(_i : GoInt)] < _p[(_j : GoInt)];
    }
    @:keep
    static public function len( _p:T_runeSlice):GoInt {
        return (_p.length);
    }
}

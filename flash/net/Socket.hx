package flash.net;
#if cpp


import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.IDataInput;
import haxe.io.Output;
import haxe.io.Error;
import haxe.io.BytesBuffer;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.Input;
import haxe.io.Output;
import haxe.io.BytesInput;
import sys.net.Socket;
import sys.net.Host;
import flash.events.ProgressEvent;
import flash.events.Event;
import cpp.vm.Thread;

class Socket extends EventDispatcher implements IDataInput /*implements IDataOutput*/ {
    public var socketInput: Input;
    public var socketOutput: Output;

    private var _socket: sys.net.Socket;
    private var _connected: Bool;
    private var _isFirstRead: Bool;
    private var _firstReadByte: Bytes;
    private var _buffer: Array<Bytes>;
    private var _host: Host;
    private var _port: Int;

    public var bytesAvailable(get,null) : Int;
    public var objectEncoding : Int;
    @:isVar
    public var endian(get, set): String;

    public var connected(get, null): Bool;

    private function get_connected(): Bool {
        return _connected;
    }

    private function get_endian(): String {
        return endian;
    }

    private function set_endian(value: String): String {
        endian = value;
        return endian;
    }

    private function get_bytesAvailable(): Int {
        return bytesAvailable;
    }

    public function new(?host: String = null, ?port: Int = 0) {
	super();
	_host = new Host(host);
	_port = port;
        _socket = new sys.net.Socket();
        _buffer = new Array<Bytes>();
        socketInput = _socket.input;
        socketOutput = _socket.output;
	Thread.create(onThreadCreated);
    }

    private function onThreadCreated(): Void {
	_socket.connect(_host, _port);
        _connected = true;
        onConnect();
        _socket.setBlocking(false);
        while(_connected) {
            _socket.waitForRead();
            _isFirstRead = true;
            fillBuffer();
            if(connected) {
                onData();
            }
        }
    }

    private inline function onConnect(): Void {
         dispatchEvent(new Event(Event.CONNECT));
    }

    private inline function onData(): Void {
        dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, bytesAvailable, 0));
    }

    public function close(): Void {
        if(connected) {
            _connected = false;
            _socket.close();
            //_socketHandler.onDisconnect(this);
            _socket = null;
            //_socketHandler = null;
            socketInput = null;
        }
    }

    public function read(): Bytes {
        try {
            var retVal: Bytes = socketInput.read(1);
            _isFirstRead = false;
            return retVal;
        } catch(e: Dynamic) {
            if(_isFirstRead) {
                close();
            }
        }
        return null;
    }

    private inline function readByteFromBuffer(num: Int = 1): Input {
        var byteBuffer: BytesBuffer = new BytesBuffer();
        for(i in 0...num) {
            byteBuffer.add(_buffer.shift());
        }
        return new BytesInput(byteBuffer.getBytes());
    }

    private inline function fillBuffer(): Void {
        var readByte: Bytes = null;
        while(true) {
            readByte = read();
            if(readByte == null) {
                break;
            }
            _buffer.push(readByte);
        }
        bytesAvailable = _buffer.length;
    }

    public function readBytes(bytes: flash.utils.ByteArray, offset: Int = 0, length: Int = 0): Void {

    }

    public function readBoolean():Bool {
        return readByteFromBuffer().readByte() == 1 ? true : false;
    }

    public function readByte():Int {
        return readByteFromBuffer().readByte();
    }

    public function readDouble():Float {
        return readByteFromBuffer(8).readDouble();
    }

    public function readFloat():Float {
        return readByteFromBuffer(4).readFloat();
    }

    public function readInt():Int {
        return readByteFromBuffer(4).readInt32();
    }

    public function readMultiByte(length:Int, charSet:String):String {
        return readUTFBytes(length);
    }

    public function readShort():Int {
        return readByteFromBuffer(2).readInt16();
    }

    public function readUTF():String {
        return readUTFBytes(1);
    }

    public function readUTFBytes(length:Int):String {
        return readByteFromBuffer(length).readString(length);
    }

    public function readUnsignedByte():Int {
        return socketInput.readByte();
    }

    public function readUnsignedInt():Int {
        return readInt();
    }

    public function readUnsignedShort():Int {
        return readShort();
    }

    public function writeBoolean( value:Bool ):Void {
        if(value) {
            socketOutput.writeByte(1);
        } else {
            socketOutput.writeByte(0);
        }
        socketOutput.flush();
    }

    public function writeByte( value:Int ):Void {
        socketOutput.writeByte(value);
        socketOutput.flush();
    }

    public function writeDouble( value:Float ):Void {
        socketOutput.writeDouble(value);
        socketOutput.flush();
    }

    public function writeFloat( value:Float ):Void {
        socketOutput.writeFloat(value);
        socketOutput.flush();
    }

    public function writeInt( value:Int ):Void {
        socketOutput.writeInt32(value);
        socketOutput.flush();
    }

    public function writeMultiByte( value:String, charSet:String ):Void {
        socketOutput.writeString(value);
    }

    public function writeObject( object:Dynamic ):Void {
        trace("unsupported");
    }

    public function writeShort( value:Int ):Void {
        socketOutput.writeInt16(value);
    }

    public function writeUTF( value:String ):Void {
        socketOutput.writeString(value);
    }

    public function writeUTFBytes( value:String ):Void {
        socketOutput.writeString(value);
    }

    public function writeUnsignedInt( value:Int ):Void {
        socketOutput.writeUInt24(value);
    }
	
}


#end

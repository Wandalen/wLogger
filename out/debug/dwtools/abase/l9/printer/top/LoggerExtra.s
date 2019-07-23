(function _Logger_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  if( typeof wPrinterTop === 'undefined' )
  require( '../PrinterTop.s' )

}

//
var _global = _global_;
var _ = _global_.wTools;
var Parent = _.PrinterTop;
var Self = _.Logger;

//

function _wrapProtoHandler( methodName, originalMethod, proto )
{

  debugger;
  return function()
  {
    debugger;
    logger.logUp( proto.constructor.name + '.' + methodName,'(','with',arguments.length,'arguments',')' );
    var result = originalMethod.apply( this,arguments );
    logger.logDown();
    return result;
  }

}

//

function wrapProto( proto,o )
{
  var self = this;
  var o = o || {};

  _.assert( _.objectIs( proto ) || _.routineIs( proto ) );

  if( proto.constructor.wrappedByLogger )
  return;

  proto.constructor.wrappedByLogger = true;

  console.log( 'wrapProto :',proto.constructor.name );

  var methods = o.methods || proto;
  for( var r in methods )
  {

    if( r === 'constructor' )
    continue;

    var descriptor = Object.getOwnPropertyDescriptor( proto,r );

    if( !descriptor )
    continue;

    if( !descriptor.configurable )
    continue;

    var routine = proto[ r ];

    if( !_.routineIs( routine ) )
    continue;

    proto[ r ] = _wrapProtoHandler( r,routine,proto );
    proto[ r ].original = routine;

  }

}

//

function unwrapProto( proto )
{
  var self = this;
  var o = o || {};

  _.assert( _.objectIs( proto ) || _.routineIs( proto ) );

  if( !proto.constructor.wrappedByLogger )
  return;

  proto.constructor.wrappedByLogger = false;

  console.log( 'unwrapProto :',proto.constructor.name );

  var methods = o.methods || proto;
  for( var r in methods )
  {

    if( r === 'constructor' )
    continue;

    var descriptor = Object.getOwnPropertyDescriptor( proto,r );

    if( !descriptor )
    continue;

    if( !descriptor.configurable )
    {
      continue;
    }

    var routine = proto[ r ];

    if( !_.routineIs( routine ) )
    continue;

    if( !_.routineIs( routine.original ) )
    continue;

    proto[ r ] = routine.original;

  }

}

//

function _hookConsoleToFileHandler( wasMethod, methodName, fileName )
{

  return function()
  {

    var args = arguments;

    wasMethod.apply( console,args );

    var fileProvider = _.FileProvider.Default();
    if( fileProvider.fileWrite )
    {

      var strOptions = { levels : 7 };
      fileProvider.fileWrite
      ({
        path : fileName,
        data : _.toStr( args,strOptions ) + '\n',
        append : true,
      });

    }

  };

}

//

function hookConsoleToFile( fileName )
{
  var self = this;

  require( 'include/dwtools/l3/Path.s' );
  require( 'include/dwtools/UseMid.s' );

  fileName = fileName || 'log.txt';
  fileName = _.path.join( _.path.realMainDir(),fileName );

  console.log( 'hookConsoleToFile :',fileName );

  for( var i = 0, l = self._methods.length; i < l; i++ )
  {
    var m = self._methods[ i ];
    if( m in console )
    {
      var wasMethod = console[ m ];
      console[ m ] = self._hookConsoleToFileHandler( wasMethod,m,fileName );
    }
  }

}

//

function _hookConsoleToAlertHandler( wasMethod, methodName )
{

  return function()
  {

    var args = _.arrayAppendArrays( [], [ arguments,_.diagnosticStack() ] );

    wasMethod.apply( console,args );
    alert( args.join( '\n' ) );

  }

}

//

function hookConsoleToAlert()
{
  var self = this;

  console.log( 'hookConsoleToAlert' );

  for( var i = 0, l = self._methods.length; i < l; i++ )
  {
    var m = self._methods[ i ];
    if( m in console )
    {
      var wasMethod = console[ m ];
      console[ m ] = self._hookConsoleToAlertHandler( wasMethod,m );
    }
  }

}

//

function _hookConsoleToDomHandler( o, wasMethod, methodName )
{

  return function()
  {

    wasMethod.apply( console,arguments );
    var text = [].join.call( arguments,' ' );
    o.consoleDom.prepend( '<p>' + text + '</p>' );

  }

}

//

function hookConsoleToDom( o )
{
  var self = this;
  var o = o || {};
  var $ = jQuery;

  _.timeReady( function()
  {

    if( !o.dom )
    o.dom = $( document.body );

    var consoleDom = o.consoleDom = $( '<div>' ).appendTo( o.dom );
    consoleDom.css
    ({
      'display' : 'block',
      'position' : 'absolute',
      'bottom' : '0',
      'width' : '100%',
      'height' : '50%',
      'z-index' : '10000',
      'background-color' : 'rgba( 255,0,0,0.1 )',
      'overflow-x' : 'hidden',
      'overflow-y' : 'auto',
      'padding' : '1em',
    });

    console.log( 'hookConsoleToDom' );

    for( var i = 0, l = self._methods.length; i < l; i++ )
    {
      var m = self._methods[ i ];
      if( m in console )
      {
        var wasMethod = console[ m ];
        console[ m ] = self._hookConsoleToDomHandler( o,wasMethod,m );
      }
    }

  });

}

//

function _hookConsoleToServerSend( o, data )
{
  var self = this;

  var request = $.ajax
  ({
    url : o.url,
    crossDomain : true,
    method : 'post',
    /*dataType : 'json',*/
    data : JSON.stringify( data ),
    error : _.routineJoin_( self,self.unhookConsole,[ false ] ),
  });

}

//

function _hookConsoleToServerHandler( o, originalMethod, methodName )
{
  var self = this;

  return function()
  {

    originalMethod.apply( console,arguments );
    var text = [].join.call( arguments,' ' );
    var data = {};
    data.text = text;
    data.way = 'message';
    data.method = methodName;
    data.o = o;

    self._hookConsoleToServerSend( o,data );

  }

}

//

function hookConsoleToServer( o )
{
  var self = this;

  if( console._hook )
  return;

  console._hook = 'hookConsoleToServer';

  // var

  var $ = jQuery;
  var o = o || {};
  var optionsDefault =
  {
    url : null,
    id : null,
    pathname : '/log',
  }

  throw _.err( 'not tested' );

  _.assertMapHasOnly( o,optionsDefault,_.uri.str.components );
  _.mapSupplement( o,optionsDefault );

  if( !o.url )
  o.url = _.uri.for( o );

  if( !o.id )
  o.id = _.numberRandomInt( 1 << 30 );

  console.log( 'hookConsoleToServer :',o.url );

  //

  for( var i = 0, l = self._methods.length; i < l; i++ )
  {
    var m = self._methods[ i ];
    if( m in console )
    {
      var originalMethod = console[ m ];
      console[ m ] = self._hookConsoleToServerHandler( o,originalMethod,m );
      console[ m ].original = originalMethod;
    }
  }

  // handshake

  var data = {};
  data.way = 'handshake';
  data.o = o;

  self._hookConsoleToServerSend( o,data );

}

//

function unhookConsole( force )
{
  var self = this;

  if( !console._hook && !force )
  return;

  console._hook = false;
  console.log( 'unhookConsole :' );

  for( var i = 0, l = self._methods.length; i < l; i++ )
  {
    var m = self._methods[ i ];
    if( m in console )
    {
      _.assert( _.routineIs( console[ m ].original ) );
      console[ m ] = console[ m ].original;
    }
  }

}

//

var _methods =
[
  'log', 'assert', 'clear', 'count',
  'debug', 'dir', 'dirxml', 'error',
  'exception', 'group', 'groupCollapsed',
  'groupEnd', 'info', 'profile', 'profileEnd',
  'table', 'time', 'timeEnd', 'timeStamp',
  'trace', 'warn'
];

// --
// relations
// --

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
}

// --
// declare
// --

var Proto =
{

  _wrapProtoHandler,
  wrapProto,
  unwrapProto,

  _hookConsoleToFileHandler,
  hookConsoleToFile,

  _hookConsoleToAlertHandler,
  hookConsoleToAlert,

  _hookConsoleToDomHandler,
  hookConsoleToDom,

  _hookConsoleToServerSend,
  _hookConsoleToServerHandler,
  hookConsoleToServer,

  unhookConsole,

  // var

  _methods,

  // relations


  Composes,
  Aggregates,
  Associates,

}

//

_.classExtend( Self,Proto );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();

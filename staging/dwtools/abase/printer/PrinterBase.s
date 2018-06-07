(function _PrinterBase_s_() {

'use strict'; 

var isBrowser = true;
if( typeof module !== 'undefined' )
{
  isBrowser = false;

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let _externalTools = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );/*hhh*/
    }
    catch( err )
    {
      _externalTools = 1;
      require( 'wTools' );
    }
    if( !_externalTools )
    require( toolsPath );
  }

  var _global = _global_; var _ = _global_.wTools;

  _.include( 'wCopyable' );
  _.include( 'wStringer' );
  _.include( 'wStringsExtra' );

}

//

/**
 * @class wPrinterBase
 */

var _global = _global_; var _ = _global_.wTools;
var Parent = null;
var Self = function wPrinterBase( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterBase';

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  return self;
}

// --
// write
// --

function write()
{
  var self = this;

  if( !self.verboseEnough( arguments ) )
  return;

  /* */

  // if( arguments.length === 1 )
  // if( self.canPrintFrom( arguments[ 0 ] ) )
  // {
  //   self.printFrom( arguments[ 0 ] );
  //   return;
  // }

  /* */

  var o = Object.create( null );
  o.input = arguments;

  self._writeBegin( o );

  o = self._writePrepare( o );

  _.assert( _.mapIs( o ) );
  _.assert( _.arrayLike( o.input ) );
  _.assert( _.arrayLike( o.outputForTerminal ) );
  _.assert( _.arrayLike( o.output ) );

  if( self.onWrite )
  self.onWrite( o );

  self._writeEnd( o );

  return o;
}

//

function _writeBegin( args )
{
  _.assert( arguments.length === 1 );
}

//

function _writePrepare( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.arrayLike( o.input ) );

  /*o.naked = _.strConcat.apply( _,args );*/
  o.pure = self._strConcat( o.input );
  o.output = [ o.pure ];
  o.outputForTerminal = [ o.pure ];

  return o;
}

//

function _writeEnd( args )
{
  _.assert( arguments.length === 1 );
}

//

function _strConcat( args )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( !_.strConcat )
  return _.str.apply( _,args );

  var optionsForStr =
  {
    linePrefix : self._prefix,
    linePostfix : self._postfix,
  }

  var result = _.strConcat.apply( optionsForStr,args );

  return result;
}

// --
// leveling
// --

// !!! poor description

/**
 * Increases value of logger level property by( dLevel ).
 *
 * If argument( dLevel ) is not specified, increases by one.
 *
 * @example
 * var l = new _.Logger();
 * l.up( 2 );
 * console.log( l.level )
 * //returns 2
 * @method up
 * @throws { Exception } If more then one argument specified.
 * @throws { Exception } If( dLevel ) is not a finite number.
 * @memberof wPrinterBase
 */

function up( dLevel )
{
  var self = this;

  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level+dLevel );

}

//

// !!! poor description

/**
 * Decreases value of logger level property by( dLevel ).
 * If argument( dLevel ) is not specified, decreases by one.
 *
 * @example
 * var l = new _.Logger();
 * l.up( 2 );
 * l.down( 2 );
 * console.log( l.level )
 * //returns 0
 * @method down
 * @throws { Exception } If more then one argument specified.
 * @throws { Exception } If( dLevel ) is not a finite number.
 * @memberof wPrinterBase
 */

function down( dLevel )
{
  var self = this;

  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level-dLevel );

}

//

function levelSet( level )
{
  var self = this;

  _.assert( level >= 0, 'levelSet : cant go below zero level to',level );
  _.assert( isFinite( level ) );

  var dLevel = level - self[ symbolForLevel ];

  self[ symbolForLevel ] = level ;

}

// --
// etc
// --

function verboseEnough( args )
{
  var self = this;
  return true;
}

//

function canPrintFrom( src )
{
  var self = this;

  if( !_.objectIs( src ) )
  return false;

  if( _.routineIs( src._print ) && _.routineIs( src._print.makeIterator ) )
  return true;

  // if( _.routineIs( src.print ) )
  // return true;

  return false;
}

//

function printFrom( src )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( src._print ) );
  _.assert( _.routineIs( src._print.makeIterator ) );
  _.assert( src._print.length === 2 );

  var iterator = src._print.makeIterator({ printer : self });
  var iteration = iterator.iterationNew();

  Object.preventExtensions( iterator );
  Object.preventExtensions( iteration );

  src._print( iteration,iterator );

}

// --
// relationships
// --

var symbolForLevel = Symbol.for( 'level' );

var Composes =
{

  level : 0,
  onWrite : null,

  name : 'xxx',

}

var Aggregates =
{
}

var Associates =
{
}

// --
// prototype
// --

var Proto =
{

  // routine

  init : init,


  // write

  write : write,
  _writeBegin : _writeBegin,
  _writePrepare : _writePrepare,
  _writeEnd : _writeEnd,
  _strConcat : _strConcat,


  // leveling

  up : up,
  down : down,
  levelSet : levelSet,


  // etc

  verboseEnough : verboseEnough,
  canPrintFrom : canPrintFrom,
  printFrom : printFrom,


  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

_.accessor
({
  object : Self.prototype,
  names :
  {
    level : 'level',
  }
});

//

_[ Self.nameShort ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();

(function _PrinterBase_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../Tools.s' );

  _.include( 'wCopyable' );
  _.include( 'wStringer' );
  _.include( 'wStringsExtra' );

}

//

/**
 * @classdesc Describes basic abilities of the printer: input transformation, verbosity level change.
 * @class wPrinterBase
 */

var _global = _global_;
var _ = _global_.wTools;
var Parent = null;
var Self = function wPrinterBase( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PrinterBase';

// --
// inter
// --

function init( o )
{
  var self = this;

  _.workpiece.initFields( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  return self;
}

// --
// transform
// --

function transform( o )
{
  var self = this;

  _.assertMapHasAll( o, transform.defaults );

  o = self._transformBegin( o );

  if( !o )
  return;

  o = self._transformAct( o );

  _.assert( _.mapIs( o ) );
  _.assert( _.longIs( o.input ) );

  o = self._transformEnd( o );

  return o;
}

transform.defaults =
{
  input : null,
}

//

function _transformBegin( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return o;
}

//

function _transformAct( o )
{
  var self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.longIs( o.input ) );

  o.pure = self._strConcat( o.input );
  o.outputForPrinter = [ o.pure ];
  o.outputForTerminal = [ o.pure ];

  /* !!! remove later */

  _.accessor.forbid
  ({
    object : o,
    names :
    {
      output : 'output',
    }
  });

  return o;
}

//

function _transformEnd( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return o;
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
 * var l = new _.Logger({ output : console });
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
 * var l = new _.Logger({ output : console });
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

function write()
{
  var self = this;

  var o = self.transform({ input : arguments });

  _.assert( o.outputForPrinter );

  return self;
}

//

function _strConcat( args )
{
  var self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !_.strConcat )
  return _.str.apply( _,args );

  var o2 =
  {
    linePrefix : self._prefix,
    linePostfix : self._postfix,
    onToStr : onToStr,
  }

  var result = _.strConcat( args, o2 );

  return result;

  function onToStr( src, op )
  {
    if( _.errIs( src ) && _.color )
    {
      src = _.err( src );
      let result = src.stack;
      result = _.color.strFormat( result, 'negative' );
      return result;
    }
    return _.toStr( src, op.optionsForToStr );
  }
}

//
//
// function canPrintFrom( src )
// {
//   var self = this;
//
//   if( !_.objectIs( src ) )
//   return false;
//
//   if( _.routineIs( src._print ) && _.routineIs( src._print.makeIterator ) )
//   return true;
//
//   // if( _.routineIs( src.print ) )
//   // return true;
//
//   return false;
// }
//
// //
//
// function printFrom( src )
// {
//   var self = this;
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.routineIs( src._print ) );
//   _.assert( _.routineIs( src._print.makeIterator ) );
//   _.assert( src._print.length === 2 );
//
//   var iterator = src._print.makeIterator({ printer : self });
//   var iteration = iterator.iterationNew();
//
//   Object.preventExtensions( iterator );
//   Object.preventExtensions( iteration );
//
//   src._print( iteration,iterator );
//
// }

// --
// relations
// --

var symbolForLevel = Symbol.for( 'level' );

var Composes =
{

  name : '',
  level : 0,

}

var Aggregates =
{
}

var Associates =
{
}

var Accessors =
{
  level : 'level',
}

var Statics =
{
  MetaType : 'Printer',
}

// --
// declare
// --

var Proto =
{

  // routine

  init,

  // transform

  transform,
  _transformBegin,
  _transformAct,
  _transformEnd,

  // leveling

  up,
  down,
  levelSet,

  // etc

  write,
  _strConcat,

  // canPrintFrom,
  // printFrom,

  // relations


  Composes,
  Aggregates,
  Associates,
  Accessors,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

// --
// export
// --

_[ Self.shortName ] = Self;

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();

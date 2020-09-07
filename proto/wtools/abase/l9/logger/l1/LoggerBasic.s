(function _LoggerBasic_s_()
{

'use strict';

/**
 * @classdesc Describes basic abilities of the printer: input transformation, verbosity level change.
 * @class wLoggerBasic
 * @namespace Tools
 * @module Tools/base/Logger
 */

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = wLoggerBasic;
function wLoggerBasic( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'LoggerBasic';

// --
// inter
// --

function init( o )
{
  let self = this;

  _.workpiece.initFields( self );

  if( self[ chainerSymbol ] === undefined )
  self[ chainerSymbol ] = null;

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
  let self = this;

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
  let self = this;

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

/* qqq : poor description */

/**
 * Increases value of logger level property by( dLevel ).
 *
 * If argument( dLevel ) is not specified, increases by one.
 *
 * @example
 * let l = new _.Logger({ output : console });
 * l.up( 2 );
 * console.log( l.level )
 * //returns 2
 * @method up
 * @throws { Exception } If more then one argument specified.
 * @throws { Exception } If( dLevel ) is not a finite number.
 * @class wLoggerBasic
 * @namespace Tools
 * @module Tools/base/Logger
 */

function up( dLevel )
{
  let self = this;

  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level+dLevel );

}

//

/**
 * Decreases value of logger level property by( dLevel ).
 * If argument( dLevel ) is not specified, decreases by one.
 *
 * @example
 * let l = new _.Logger({ output : console });
 * l.up( 2 );
 * l.down( 2 );
 * console.log( l.level )
 * //returns 0
 * @method down
 * @throws { Exception } If more then one argument specified.
 * @throws { Exception } If( dLevel ) is not a finite number.
 * @class wLoggerBasic
 * @namespace Tools
 * @module Tools/base/Logger
 */

/* qqq : poor description */

function down( dLevel )
{
  let self = this;

  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level-dLevel );

}

//

function levelSet( level )
{
  let self = this;

  _.assert( level >= 0, 'levelSet : cant go below zero level to', level );
  _.assert( isFinite( level ) );

  let dLevel = level - self[ levelSymbol ];

  self[ levelSymbol ] = level ;

}

// --
// etc
// --

function _writeAct( channelName, args )
{
  let self = this;

  let o = self.transform({ input : args, channelName });

  _.assert( o.outputForPrinter );

  return o;
  // return self;
}

// function write()
// {
//   let self = this;
//
//   let o = self.transform({ input : arguments });
//
//   _.assert( o.outputForPrinter );
//
//   return self;
// }

//

function _strConcat( args )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !_.strConcat )
  return _.toStrSimple.apply( _, args );

  let o2 =
  {
    linePrefix : self._prefix,
    linePostfix : self._postfix,
    onToStr,
  }

  let result = _.strConcat( args, o2 );

  return result;

  function onToStr( src, op )
  {
    if( _.errIs( src ) && _.color )
    {
      src = _.err( src );
      let result = src.stack;
      result = _.ct.format( result, 'negative' );
      return result;
    }
    return _.toStr( src, op.optionsForToStr );
  }
}

//

function Init()
{
  let cls = this;

  _.assert( cls.Channel.length > 0 );

  for( let i = 0 ; i < cls.Channel.length ; i++ )
  channelDeclare( cls.Channel[ i ] );

  function channelDeclare( channel )
  {
    let r =
    {
      [ channel ] : function()
      {
        this._writeAct( channel, arguments );
      }
    }
    cls.prototype[ channel ] = r[ channel ];
  }

}

// --
// relations
// --

let levelSymbol = Symbol.for( 'level' );
let chainerSymbol = Symbol.for( 'chainer' );

let Channel =
[
  'log',
  'error',
  'info',
  'warn',
  'debug'
];

let Composes =
{

  name : '',
  level : 0,

}

let Aggregates =
{
}

let Associates =
{
}

let Accessors =
{
  level : 'level',
}

let Statics =
{
  MetaType : 'Printer',
  Channel,
  Init,
}

// --
// declare
// --

let Proto =
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

  _writeAct,
  _strConcat,

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
Self.Init();

// --
// export
// --

_[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

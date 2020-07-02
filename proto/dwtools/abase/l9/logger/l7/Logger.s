(function _Logger_s_() {

'use strict';

// if( typeof module !== 'undefined' )
// {
//
//   if( typeof wLoggerTop === 'undefined' )
//   require( '../LoggerTop.s' );
//
// }

//

/**
 * @classdesc Creates a logger for printing colorful and well formatted diagnostic code on server-side or in the browser. Based on [wLoggerTop]{@link wLoggerTop}.
 * @class wLogger
 * @namespace Tools
 * @module Tools/base/Logger
 */

let _global = _global_;
let _ = _global_.wTools;
let Parent = _.LoggerTop;
let Self = function wLogger( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Logger';

//

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 | arguments.length === 1 );

  Parent.prototype.init.call( self,o );

}

// --
// relations
// --

let Composes =
{
  name : '',
}

let Aggregates =
{
}

let Associates =
{
  // output : console,
  output : null,
}

let Restricts =
{
}

let Statics =
{
}

// --
// declare
// --

let Proto =
{

  init,

  // relations


  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

_[ Self.shortName ] = Self;

if( !_global_.logger || !( _global_.logger instanceof Self ) )
_global_.logger = _global_[ 'logger' ] = new Self({ output : console, name : 'global' });

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

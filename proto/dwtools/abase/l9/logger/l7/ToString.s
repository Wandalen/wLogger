(function _ToString_s_() {

'use strict';

/**
 * @classdesc Creates a printer that collects messages into a single string. Based on [wLoggerTop]{@link wLoggerTop}.
 * @class wLoggerToString
 * @module Tools/base/Logger
 */

let _global = _global_;
let _ = _global_.wTools;
// let Parent = _.LoggerTop; /* yyy */
let Parent = _.LoggerMid;
let Self = function wLoggerToString( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'LoggerToString';

//

function init( o )
{
  let self = this;
  return Parent.prototype.init.call( self, o );
}

//

function _writeAct( channel, args )
{
  let self = this;

  let o = _.LoggerBasic.prototype._writeAct.apply( self, arguments );

  // _.assert( _.arrayIs( o.output ) );
  // _.assert( o.output.length === 1 );
  _.assert( _.strIs( o.pure ) );

  if( self.outputData )
  self.outputData += self.eol + o.pure;
  else
  self.outputData += o.pure;

  return o;
}

// --
// relations
// --

let Composes =
{
  eol : '\n',
}

let Aggregates =
{
  outputData : '',
}

let Associates =
{
}

let Restricts =
{
}

// --
// prototype
// --

let Proto =
{

  init,

  _writeAct,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

(function _aColoredMixin_s_() {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  isBrowser = false;

  var _ = _global_.wTools;

  try
  {
    _.include( 'wColor' );
  }
  catch( err )
  {
  }

}

var _ = _global_.wTools;

//

function _mixin( cls )
{

  var dstProto = cls.prototype;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( cls ) );

  _.mixinApply
  ({
    dstProto : dstProto,
    descriptor : Self,
  });

  _.accessor
  ({
    object : dstProto,
    combining : 'rewrite',
    names : Accessors,
  });

}

// --
// etc
// --

function _rgbToCode( rgb, add )
{
  // var r = rgb[ 0 ];
  // var g = rgb[ 1 ];
  // var b = rgb[ 2 ];

  // var lightness = _.color.rgbToHsl( rgb )[ 2 ];
  //
  // var ansi = 30 + ( ( Math.round( b ) << 2 ) | ( Math.round( g ) << 1 ) | Math.round( r ) );
  //
  // // why 8 ???
  //
  // if( add )
  // ansi = ansi + add;
  //
  // if( lightness === .25  )
  // ansi = '1;' + ansi;

  // var name = Object.keys( _.color.ColorMapShell );
  // for( var i = 0; i < name.length; i++ )
  // {
  //   if( _.color.ColorMapShell[ name[ i ] ] === rgb )
  //   {
  //     name = name[ i ];
  //     break;
  //   }
  // }

  var ansi = 0;
  var isLight = false;

  if( add === undefined )
  add = 0;

  var name = _.color._colorNameNearest( rgb, _.color.ColorMapShell );


  if( process.platform !== 'win32' )
  if( shellColorCodesUnix[ name ] )
  return shellColorCodesUnix[ name ] + add;

  if( _.strBegins( name, 'light' ) )
  {
    name = name.split( ' ' )[ 1 ];
    isLight = true;
  }

  ansi = 30 + shellColorCodesBase[ name ] + add;

  if( isLight )
  {
    if( process.platform === 'win32' )
    ansi = '1;' + ansi;
    else
    ansi = ansi + 60;
  }

  // console.log(ansi);

  return ansi;
}

//

function _foregroundColorGet()
{
  var self = this;
  return self[ symbolForForeground ];
}

//

function _backgroundColorGet()
{
  var self = this;
  return self[ symbolForBackground ];
}

//

function _foregroundColorSet( color )
{
  var self = this;
  var layer = 'foreground';

  self._colorSet( layer, color );
}

//

function _backgroundColorSet( color )
{
  var self = this;
  var layer = 'background';

  self._colorSet( layer, color );
}

//

function _colorSet( layer, color )
{
  var self = this;

  var symbol;
  var diagnosticInfo;

  if( layer === 'foreground' )
  symbol = symbolForForeground;
  else if( layer === 'background' )
  symbol = symbolForBackground;
  else _.assert( 0,'unexpected' );

  if( !_.color )
  {
    self[ symbol ] = null;
    return;
  }

  _.assert( _.symbolIs( symbol ) );

  if( !_.color )
  {
    color = null;
  }

  function _getColorName( map, color )
  {
    var keys = _.mapOwnKeys( map );
    for( var i = 0; i < keys.length; i++ )
    if( _.arrayIdentical( map[ keys[ i ] ], color ) )
    return keys[ i ];
  }

  /* */

  if( color && color !== 'default' )
  {
    var originalName = color;
    color = _.color.rgbaFromTry( color, null );
    var originalValue = color;
    var currentName;

    if( color )
    {
      if( isBrowser )
      {
        color = _.color.colorNearestCustom({ color : color, colorMap : _.color.ColorMap });
        currentName = _getColorName( _.color.ColorMap, color );
      }
      else
      {
        color = _.color.colorNearestCustom({ color : color, colorMap : _.color.ColorMapShell });
        currentName = _getColorName( _.color.ColorMapShell, color );
      }

      diagnosticInfo =
      {
        originalValue : originalValue,
        originalName : originalName,
        currentName : currentName,
        exact : !!_.color._colorDistance( color, originalValue )
      };

    }

  }

  /* */

  if( !color || color === 'default' )
  {
    if( self._stackIsNotEmpty( layer ) )
    self[ symbol ] = self._stackPop( layer );
    else
    self[ symbol ] = null;

    if( self.diagnosticColorsStack  )
    self.diagnosticColorsStack[ layer ].pop();
  }
  else
  {
    if( self[ symbol ] )
    self._stackPush( layer, self[ symbol ] );

    self[ symbol ] = color;
    self._isStyled = 1;

    if( !self.diagnosticColorsStack  )
    self.diagnosticColorsStack = { 'foreground' : [], 'background' : [] };

    self.diagnosticColorsStack[ layer ].push( diagnosticInfo );
  }

}

// --
// stack
// --

function _stackPush( layer, color )
{
  var self = this;

  if( !self.colorsStack )
  self.colorsStack = { 'foreground' : [], 'background' : [] };

  self.colorsStack[ layer ].push( color );
}

//

function _stackPop( layer )
{
  var self = this;

  return self.colorsStack[ layer ].pop();
}

//

function _stackIsNotEmpty( layer )
{
  var self = this;

  if( self.colorsStack && self.colorsStack[ layer ].length )
  return true;

  return false;
}

// --
// colored text
// --

/* !!! find a new home for the function */

function coloredToHtml( o )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( !_.objectIs( o ) )
  o = { src : o }

  if( !o.onStrip )
  o.onStrip = self._handleStrip || _handleStrip;

  _.routineOptions( coloredToHtml,o );
  _.assert( _.strIs( o.src ) || _.arrayIs( o.src ) );
  _.assert( _.routineIs( o.onStrip ) );

  if( _.arrayIs( o.src ) )
  {
    var optionsForStr =
    {
      delimeter  : ''
    }
    o.src = _.strConcat.apply( optionsForStr ,o.src );
  }

  var result = '';
  var spanCount = 0;

  var splitted = _.strExtractStrips( o.src, { onStrip : o.onStrip } );

  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      var style = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( color && color !== 'default' )
      {
        var color = _.color.rgbaFromTry( color, null );
        if( color )
        color = _.color.colorNearestCustom({ color : color, colorMap : _.color.ColorMap })
      }

      if( style === 'foreground')
      {
        self.foregroundColor = color;
      }
      else if( style === 'background')
      {
        self.backgroundColor = color;
      }

      var fg = self.foregroundColor;
      var bg = self.backgroundColor;

      if( !fg || fg === 'default' )
      fg = null;

      if( !bg || bg === 'default' )
      bg = null;

      if( color === 'default' && spanCount )
      {
        result += `</${o.tag}>`;
        spanCount--;
      }
      else
      {
        var style = '';

        if( o.compact )
        {
          if( fg )
          style += `color:${ _.color.colorToRgbaHtml( fg ) };`;

          if( bg )
          style += `background:${ _.color.colorToRgbaHtml( bg ) };`;
        }
        else
        {
          fg = fg || 'transparent';
          bg = bg || 'transparent';
          style = `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };`;
        }

        if( style.length )
        result += `<${o.tag} style='${style}'>`;
        else
        result += `<${o.tag}>`;

        spanCount++;
      }
    }
    else
    {
      var text = _.strReplaceAll( splitted[ i ], '\n', '<br>' );

      if( !o.compact && !spanCount )
      {
        result += `<${o.tag}>${text}</${o.tag}>`;
      }
      else
      result += text;
    }
  }

  _.assert( spanCount === 0 );

  return result;
}

coloredToHtml.defaults =
{
  src : null,
  tag : 'span',
  compact : true,
  onStrip : null,
}

//

function _writePrepareHtml( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );
  _.assert( o.output.length === 1 );

  o.outputForTerminal = [ self.coloredToHtml( o.output[ 0 ] ) ];

  return o;
}

//

function _writePrepareShell( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  var result = '';

  var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
  var layersOnly = true;

  splitted.forEach( function( strip )
  {

    if( _.arrayIs( strip ) )
    {
      self._handleDirective( strip );

      if( self.ignoreDirectives )
      {
        if( strip[ 0 ] !== 'ignoreDirectives' )
        strip = '#' + strip[ 0 ] + ' : ' + strip[ 1 ] + '#';
      }
    }

    if( _.strIs( strip ) )
    {
      layersOnly = false;

      if( self.usingColorFromStack )
      {
        // if( self.foregroundColor && self.backgroundColor )
        self._diagnosticColorCheck();

        if( self.foregroundColor )
        result += `\x1b[${ self._rgbToCode( self.foregroundColor ) }m`;

        if( self.backgroundColor )
        result += `\x1b[${ self._rgbToCode( self.backgroundColor, 10 ) }m`;
      }

      result += strip;

      if( self.usingColorFromStack )
      {
        if( self.backgroundColor )
        result += `\x1b[49m`;
        if( self.foregroundColor )
        result += `\x1b[39m`;
      }
    }

  });

  // if( layersOnly && splitted.length )
  // o.outputForTerminal = [];
  // else
  o.outputForTerminal = [ result ];

  return o;
}

//

function _writePrepareBrowser( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  var result = [ '' ];

  var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
  if( splitted.length === 1 && !self._isStyled )
  {
    if( !_.arrayIs( splitted[ 0 ] ) )
    return splitted;
  }

  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      self._handleDirective( splitted[ i ] );

      if( !self.foregroundColor && !self.backgroundColor )
      self._isStyled = 0;
      else if( !!self.foregroundColor | !!self.backgroundColor )
      self._isStyled = 1;
    }
    else
    {
      if( ( !i && !self._isStyled ) || !self.usingColorFromStack )
      {
        result[ 0 ] += splitted[ i ];
      }
      else
      {
        var fg = self.foregroundColor || 'none';
        var bg = self.backgroundColor || 'none';

        result[ 0 ] += `%c${ splitted[ i ] }`;
        result.push( `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };` );
      }
    }
  }

  o.outputForTerminal = result;

  return o;
}

//

function _writePrepareWithoutColors( o )
{
  var self = this;
  var result = '';

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
  for( var i = 0 ; i < splitted.length ; i++ )
  {
    if( _.strIs( splitted[ i ] ) )
    result += splitted[ i ];
  }

  o.outputForTerminal = [ result ];

  return o;
}

//

function _handleStrip( strip )
{
  var allowedKeys = [ 'bg', 'background', 'fg', 'foreground', 'coloring', 'trackingColor', 'ignoreDirectives' ];
  var parts = strip.split( ' : ' );
  if( parts.length === 2 )
  {
    if( allowedKeys.indexOf( parts[ 0 ] ) === -1 )
    return;
    return parts;
  }
}

//

function _handleDirective( directive )
{
  var self = this;

  var name = directive[ 0 ];
  var value = directive[ 1 ];

  if( name === 'ignoreDirectives' )
  {
    self.ignoreDirectives = _.boolFrom( value );
  }

  if( self.ignoreDirectives )
  return;

  if( self.trackingColor )
  {
    if( name === 'foreground' )
    {
      self.foregroundColor = value;
    }
    if( name === 'background' )
    {
      self.backgroundColor = value;
    }
  }

  if( name === 'coloring' )
  {
    self.usingColorFromStack = _.boolFrom( value );
  }
  if( name === 'trackingColor' )
  {
    self.trackingColor = _.boolFrom( value );
  }
}

//

function _writePrepare( original )
{

  return function _writePrepare( o )
  {
    var self = this;

    _.assert( arguments.length === 1 );
    _.assert( _.mapIs( o ) );

    o = original.call( self,o );

    _.assert( _.strIs( o.pure ) );
    _.assert( _.arrayLike( o.input ) );
    _.assert( _.arrayLike( o.output ) );
    _.assert( o.output.length === 1 )

    if( _.color && self.coloring )
    {

      if( self.permanentStyle )
      {
        o.output[ 0 ] = _.color.strFormat( o.output[ 0 ],self.permanentStyle );
      }

      if( self.coloringConnotation )
      {
        if( self.attributes.connotation === 'positive' )
        o.output[ 0 ] = _.color.strFormat( o.output[ 0 ],'positive' );
        else if( self.attributes.connotation === 'negative' )
        o.output[ 0 ] = _.color.strFormat( o.output[ 0 ],'negative' );
      }

      if( self.coloringHeadAndTail )
      if( self.attributes.head || self.attributes.tail )
      if( _.strStrip( o.pure ) )
      {
        var reserve = self.verbosityReserve();
        if( self.attributes.head && reserve > 1 )
        o.output[ 0 ] = _.color.strFormat( o.output[ 0 ],'head' );
        else if( self.attributes.tail && reserve > 1 )
        o.output[ 0 ] = _.color.strFormat( o.output[ 0 ],'tail' );
      }

      if( !self.rawOutput )
      if( !self.passingRawColor )
      {
        if( self.writingToHtml )
        self._writePrepareHtml( o );
        else if( !isBrowser && !module.isBrowser )
        self._writePrepareShell( o );
        else
        self._writePrepareBrowser( o );
      }

    }
    else
    {
      self._writePrepareWithoutColors( o );
    }

    _.assert( _.arrayIs( o.output ) );

    return o;
  }

}

// --
// topic
// --

function topic()
{
  var self = this;

  // debugger;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  // debugger;
  result = _.color.strFormatForeground( _.color.strFormatBackground( result,'white' ), 'black' );

  this.log();
  this.log( result );
  this.log();

  return result;
}

//

function topicUp()
{
  var self = this;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  debugger;
  result = _.color.strFormatForeground( _.color.strFormatBackground( result,'white' ), 'black' );

  this.log();
  this.logUp( result );
  this.log();

  return result;
}

//

function topicDown()
{
  var self = this;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  debugger;
  result = _.color.strFormatForeground( _.color.strFormatBackground( result,'white' ), 'black' );

  this.log();
  this.logDown( result );
  this.log();

  return result;
}

//

function styleSet( style )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( style ) );

  if( style === 'default' )
  {
    self.foregroundColor = 'default';
    self.backgroundColor = 'default';
    return;
  }

  var style = _.color.strColorStyle( style );

  if( !style )
  return;

  if( style.fg )
  self.foregroundColor = style.fg;

  if( style.bg )
  self.backgroundColor = style.bg;

}

//

function _diagnosticColorCheck()
{
  var self = this;

  if( isBrowser )
  return;

  if( !self.foregroundColor || !self.backgroundColor )
  return;

  var stackFg = self.diagnosticColorsStack[ 'foreground' ];
  var stackBg = self.diagnosticColorsStack[ 'background' ];

  var fg = stackFg[ stackFg.length - 1 ];
  var bg = stackBg[ stackBg.length - 1 ];

  /* */

  var result = {};

  if( self.diagnosticColor )
  result.ill = self._diagnosticColor( fg, bg );

  if( self.diagnosticColorCollapse )
  result.collapse = self._diagnosticColorCollapse( fg, bg );

  return result;

}

//

function _diagnosticColor( fg, bg )
{
  var self = this;
  var ill = false;

  for( var i = 0; i < illColorCombinations.length; i++ )
  {
    var combination = illColorCombinations[ i ];
    if( combination.fg === fg.originalName && combination.bg === bg.originalName )
    // if( combination.platform === process.platform )
    {
      self.diagnosticColor = 0;
      ill = true;
      // logger.foregroundColor = 'blue';
      // logger.backgroundColor = 'yellow';
      logger.styleSet( 'info.negative' );
      logger.warn( 'Warning!. Ill colors combination: ' );
      logger.warn( 'fg : ', fg.currentName, self.foregroundColor );
      logger.warn( 'bg : ', bg.currentName, self.backgroundColor );
      logger.warn( 'platform : ', combination.platform );
      logger.styleSet( 'default' );
      // logger.foregroundColor = 'default';
      // logger.backgroundColor = 'default';
      // break;
    }
  }

  return ill;
}

//

function _diagnosticColorCollapse( fg, bg )
{
  var self = this;
  var collapse = false;

  if( _.arrayIdentical( self.foregroundColor, self.backgroundColor ) )
  {
    if( fg.originalName !== bg.originalName )
    {
      var diff = _.color._colorDistance( fg.originalValue, bg.originalValue );
      if( diff <= 0.25 )
      collapse = true;
    }
  }

  if( collapse )
  {
    // logger.foregroundColor = 'blue';
    // logger.backgroundColor = 'yellow';
    self.diagnosticColorCollapse = 0;
    logger.styleSet( 'info.negative' );
    logger.warn( 'Warning: Color collapse in native terminal.' );
    logger.warn( 'fg passed : ', fg.originalName, fg.originalValue );
    logger.warn( 'fg set : ', fg.currentName,self.foregroundColor );
    logger.warn( 'bg passed: ', bg.originalName, bg.originalValue );
    logger.warn( 'bg set : ',bg.currentName, self.backgroundColor );
    logger.styleSet( 'default' );
    // logger.foregroundColor = 'default';
    // logger.backgroundColor = 'default';
  }

  return collapse;
}

// --
// type
// --

var symbolForLevel = Symbol.for( 'level' );
var symbolForForeground = Symbol.for( 'foregroundColor' );
var symbolForBackground = Symbol.for( 'backgroundColor' );

var shellColorCodesBase =
{
  'black'           : 0,
  'red'             : 1,
  'green'           : 2,
  'yellow'          : 3,
  'blue'            : 4,
  'magenta'         : 5,
  'cyan'            : 6,
  'white'           : 7
}

var shellColorCodesUnix =
{
  'white'           : 37,
  'light white'     : 97,
}

var illColorCombinations =
[
  { fg : 'black', bg : 'light yellow', platform : 'win32' },
  { fg : 'black', bg : 'yellow', platform : 'win32' },
  { fg : 'black', bg : 'blue', platform : 'win32' },
  { fg : 'green', bg : 'cyan', platform : 'win32' },
  { fg : 'red', bg : 'magenta', platform : 'win32' },
  { fg : 'blue', bg : 'black', platform : 'win32' },
  { fg : 'yellow', bg : 'cyan', platform : 'win32' },
  { fg : 'cyan', bg : 'yellow', platform : 'win32' },
  { fg : 'cyan', bg : 'green', platform : 'win32' },
  { fg : 'magenta', bg : 'red', platform : 'win32' },
  { fg : 'light black', bg : 'light yellow', platform : 'win32' },
  { fg : 'light black', bg : 'yellow', platform : 'win32' },

  /* */

  // { fg : 'white', bg : 'light yellow', platform : 'darwin' },
  { fg : 'green', bg : 'cyan', platform : 'darwin' },
  { fg : 'yellow', bg : 'cyan', platform : 'darwin' },
  { fg : 'blue', bg : 'light blue', platform : 'darwin' },
  { fg : 'blue', bg : 'black', platform : 'darwin' },
  { fg : 'cyan', bg : 'yellow', platform : 'darwin' },
  { fg : 'cyan', bg : 'green', platform : 'darwin' },
  // { fg : 'light yellow', bg : 'white', platform : 'darwin' },
  { fg : 'light red', bg : 'light magenta', platform : 'darwin' },
  { fg : 'light magenta', bg : 'light red', platform : 'darwin' },
  { fg : 'light blue', bg : 'blue', platform : 'darwin' },
  // { fg : 'light white', bg : 'light cyan', platform : 'darwin' },
  { fg : 'light green', bg : 'light cyan', platform : 'darwin' },
  { fg : 'light cyan', bg : 'light green', platform : 'darwin' },

  /* */

  { fg : 'green', bg : 'cyan', platform : 'linux' },
  { fg : 'blue', bg : 'magenta', platform : 'linux' },
  { fg : 'blue', bg : 'light black', platform : 'linux' },
  { fg : 'cyan', bg : 'green', platform : 'linux' },
  { fg : 'magenta', bg : 'blue', platform : 'linux' },
  { fg : 'magenta', bg : 'light black', platform : 'linux' },
  { fg : 'light black', bg : 'blue', platform : 'linux' },
  { fg : 'light black', bg : 'magenta', platform : 'linux' },
  { fg : 'light red', bg : 'red', platform : 'linux' },
  { fg : 'light yellow', bg : 'white', platform : 'linux' },
  { fg : 'light blue', bg : 'cyan', platform : 'linux' },
  { fg : 'light magenta', bg : 'cyan', platform : 'linux' },
  { fg : 'light green', bg : 'light cyan', platform : 'linux' },
  { fg : 'light cyan', bg : 'light green', platform : 'linux' },
  { fg : 'white', bg : 'light yellow', platform : 'linux' },
  { fg : 'red', bg : 'light red', platform : 'linux' },
  { fg : 'yellow', bg : 'light green', platform : 'linux' },
  // { fg : 'light white', bg : 'light cyan', platform : 'linux' },
  { fg : 'light magenta', bg : 'light red', platform : 'linux' },

]

// --
// relationships
// --

var Composes =
{

  foregroundColor : null,
  backgroundColor : null,

  colorsStack : null,
  passingRawColor : 0,
  coloring : 1,
  coloringHeadAndTail : 1,
  coloringConnotation : 1,
  writingToHtml : 0,

  _isStyled : 0,
  _cursorSaved : 0,
  usingColorFromStack : 1,
  trackingColor : 1,
  ignoreDirectives : 0,

  permanentStyle : null,

  diagnosticColorsStack : null

}

var Aggregates =
{

}

var Associates =
{

}

var Statics =
{
  coloredToHtml : coloredToHtml,
  rawOutput : false,
  diagnosticColor : 1,
  diagnosticColorCollapse : 1,
  illColorCombinations : illColorCombinations
}

var Accessors =
{
  foregroundColor : 'foregroundColor',
  backgroundColor : 'backgroundColor',
}

// --
// proto
// --

var Functor =
{

  _writePrepare : _writePrepare,

}

var Extend =
{

  // stack

  _stackPush : _stackPush,
  _stackPop : _stackPop,
  _stackIsNotEmpty : _stackIsNotEmpty,


  // colored text

  coloredToHtml : coloredToHtml,
  _writePrepareHtml : _writePrepareHtml,
  _writePrepareShell : _writePrepareShell,
  _writePrepareBrowser : _writePrepareBrowser,
  _writePrepareWithoutColors : _writePrepareWithoutColors,

  _handleStrip : _handleStrip,
  _handleDirective : _handleDirective,

  _foregroundColorGet : _foregroundColorGet,
  _backgroundColorGet : _backgroundColorGet,
  _foregroundColorSet : _foregroundColorSet,
  _backgroundColorSet : _backgroundColorSet,
  _colorSet : _colorSet,

  _rgbToCode : _rgbToCode,
  _diagnosticColorCheck : _diagnosticColorCheck,
  _diagnosticColor : _diagnosticColor,
  _diagnosticColorCollapse : _diagnosticColorCollapse,


  // topic

  topic : topic,
  topicUp : topicUp,
  topicDown : topicDown,

  styleSet : styleSet,

  // relationships

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Statics : Statics,

}

//

var Self =
{

  extend : Extend,
  functor : Functor,

  _mixin : _mixin,

  name : 'wPrinterColoredMixin',
  nameShort : 'PrinterColoredMixin',

}

Self = _[ Self.nameShort ] = _.mixinMake( Self );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_._UsingWtoolsPrivately_ )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();

(function _aColoredMixin_s_() {

'use strict';

let isBrowser = true;
if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
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

  let _ = _global_.wTools;

  try
  {
    _.include( 'wColor' );
  }
  catch( err )
  {
  }

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = function wPrinterColoredMixin( o )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterColoredMixin';

_.assert( _.strExtractInlined );

// --
// stack
// --

function _stackPush( layer, color )
{
  let self = this;

  if( !self._colorsStack )
  self._colorsStack = { 'foreground' : [], 'background' : [] };

  self._colorsStack[ layer ].push( color );
}

//

function _stackPop( layer )
{
  let self = this;

  return self._colorsStack[ layer ].pop();
}

//

function _stackIsNotEmpty( layer )
{
  let self = this;

  if( self._colorsStack && self._colorsStack[ layer ].length )
  return true;

  return false;
}

// --
// transform
// --

function _transformActHtml( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.outputForPrinter[ 0 ] ) );
  _.assert( o.outputForPrinter.length === 1 );

  // _.assert( _.strIs( o.src ) || _.arrayIs( o.src ) );
  // _.assert( _.routineIs( o.onInlined ) );

  var options = _.mapOnly( o, _transformActHtml.defaults );
  _.routineOptions( _transformActHtml, options );

  let result = '';
  let spanCount = 0;
  let splitted = o.outputSplitted;

  for( let i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      let style = splitted[ i ][ 0 ];
      let color = splitted[ i ][ 1 ].trim();

      if( color && color !== 'default' )
      {
        let color = _.color.rgbaFromTry( color, null );
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

      let fg = self.foregroundColor;
      let bg = self.backgroundColor;

      if( !fg || fg === 'default' )
      fg = null;

      if( !bg || bg === 'default' )
      bg = null;

      if( color === 'default' && spanCount )
      {
        result += `</${options.tag}>`;
        spanCount--;
      }
      else
      {
        let style = '';

        if( options.compact )
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
        result += `<${options.tag} style='${style}'>`;
        else
        result += `<${options.tag}>`;

        spanCount++;
      }
    }
    else
    {
      let text = _.strReplaceAll( splitted[ i ], '\n', '<br>' );

      if( !options.compact && !spanCount )
      {
        result += `<${options.tag}>${text}</${options.tag}>`;
      }
      else
      result += text;
    }
  }

  _.assert( spanCount === 0 );

  o.outputForTerminal = [ result ];

  return o;
}

_transformActHtml.defaults =
{
  // src : null,
  tag : 'span',
  compact : true,
}

//

function _transformAct_nodejs( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.outputForPrinter[ 0 ] ) );

  let result = '';
  let splitted = o.outputSplitted;

  splitted.forEach( function( split )
  {
    let output = !!_.color;

    if( _.arrayIs( split ) )
    {
      self._directiveApply( split );
      if( output && self.outputRaw )
      output = 0;
      if( output && self.outputGray && _.arrayHas( self.DirectiveColoring, split[ 0 ] ) )
      output = 0;
    }
    else
    {
      output = output && !self.outputRaw && !self.outputGray;
    }

    if( _.strIs( split ) )
    {

      if( output )
      {
        self._diagnosingColorCheck();

        if( self.foregroundColor )
        result += `\x1b[${ self._rgbToCode_nodejs( self.foregroundColor ) }m`;

        if( self.backgroundColor )
        result += `\x1b[${ self._rgbToCode_nodejs( self.backgroundColor, true ) }m`;
      }

      result += split;

      if( output )
      {
        if( self.backgroundColor )
        result += `\x1b[49;0m`;
        if( self.foregroundColor )
        result += `\x1b[39;0m`;
      }
    }

  });

  o.outputForTerminal = [ result ];

  return o;
}

//

function _transformAct_browser( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.outputForPrinter[ 0 ] ) );

  let result = [ '' ];
  let splitted = o.outputSplitted;

  if( splitted.length === 1 && !self._isStyled )
  {
    if( !_.arrayIs( splitted[ 0 ] ) )
    return splitted;
  }

  for( let i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      self._directiveApply( splitted[ i ] );

      if( !self.foregroundColor && !self.backgroundColor )
      self._isStyled = 0;
      else if( !!self.foregroundColor | !!self.backgroundColor )
      self._isStyled = 1;
    }
    else
    {
      if( ( !i && !self._isStyled ) || self.outputGray )
      {
        result[ 0 ] += splitted[ i ];
      }
      else
      {
        let fg = self.foregroundColor || 'none';
        let bg = self.backgroundColor || 'none';

        result[ 0 ] += `%c${ splitted[ i ] }`;
        result.push( `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };` );
      }
    }
  }

  o.outputForTerminal = result;

  return o;
}

//

function _transformActWithoutColors( o )
{
  let self = this;
  let result = '';

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.outputForPrinter[ 0 ] ) );

  let splitted = o.outputSplitted;

  for( let i = 0 ; i < splitted.length ; i++ )
  {
    if( _.strIs( splitted[ i ] ) )
    result += splitted[ i ];
  }

  o.outputForTerminal = [ result ];

  return o;
}

//

function _transformColor( o )
{
  let self = this;

  _.assert( _.arrayIs( o.outputForPrinter ) && o.outputForPrinter.length === 1 );

  if( self.permanentStyle )
  {
    o.outputForPrinter[ 0 ] = _.color.strFormat( o.outputForPrinter[ 0 ], self.permanentStyle );
  }

  if( self.coloringConnotation )
  {
    if( self.attributes.connotation === 'positive' )
    o.outputForPrinter[ 0 ] = _.color.strFormat( o.outputForPrinter[ 0 ], 'positive' );
    else if( self.attributes.connotation === 'negative' )
    o.outputForPrinter[ 0 ] = _.color.strFormat( o.outputForPrinter[ 0 ], 'negative' );
  }

  if( self.coloringHeadAndTail )
  if( self.attributes.head || self.attributes.tail )
  if( _.strStrip( o.pure ) )
  {
    let reserve = self.verbosityReserve();
    if( self.attributes.head && reserve > 1 )
    o.outputForPrinter[ 0 ] = _.color.strFormat( o.outputForPrinter[ 0 ], 'head' );
    else if( self.attributes.tail && reserve > 1 )
    o.outputForPrinter[ 0 ] = _.color.strFormat( o.outputForPrinter[ 0 ], 'tail' );
  }

}

//

function _transformSplit( o )
{
  let self = this;
  let result = [ '' ];

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.arrayIs( o.outputForPrinter ) && o.outputForPrinter.length === 1 );
  _.assert( !o.outputSplitted );

  if( self.raw || self.rawAll )
  {
    o.outputSplitted = o.outputForPrinter;
    return;
  }

  let splitted = o.outputSplitted = self._split( o.outputForPrinter[ 0 ] );

  let inputRaw = self.inputRaw;
  let inputGray = self.inputGray;
  let outputRaw = self.outputRaw;
  let outputGray = self.outputGray;

  splitted.forEach( ( split,i ) =>
  {

    if( !_.arrayIs( split ) )
    return;

    let directive = split[ 0 ];
    let value = split[ 1 ];
    let input = true;
    // let output = true;

    if( directive === 'inputRaw' )
    inputRaw += _.boolFrom( value.trim() ) ? +1 : -1;
    else if( inputRaw )
    input = false;
    else if( inputGray && _.arrayHas( self.DirectiveColoring, directive ) )
    input = false;

    // if( outputRaw )
    // output = false;
    // else if( outputGray && _.arrayHas( self.DirectiveColoring, directive ) )
    // output = false;

    if( !input )
    {
      split = '#' + split[ 0 ] + ':' + split[ 1 ] + '#';
      splitted[ i ] = split;
      return;
    }

    if( directive === 'inputGray' )
    inputGray += _.boolFrom( value.trim() ) ? +1 : -1;
    if( directive === 'outputRaw' )
    outputRaw += _.boolFrom( value.trim() ) ? +1 : -1;
    if( directive === 'outputGray' )
    outputGray += _.boolFrom( value.trim() ) ? +1 : -1;

  });

  o.outputForPrinter = [ self._join( splitted ) ];

}

// --
//
// --

function _join( splitted )
{
  let self = this;
  _.assert( _.arrayIs( splitted ) );

  let result = '';
  splitted.forEach( ( split,i ) =>
  {
    if( _.strIs( split ) )
    result += split
    else if( _.arrayIs( split ) )
    result += '#' + split.join( ':' ) + '#';
    else _.assert( 0 );
  });

  return result;
}

//

function _split( src )
{
  let self = this;
  _.assert( _.strIs( src ) );
  let splitted = _.strExtractInlined
  ({
    src : src,
    onInlined : self._splitHandle.bind( self ),
    preservingEmpty : 0,
    stripping : 0,
  });
  return splitted;
}

//

function _splitHandle( split )
{
  let self = this;
  let parts = split.split( ':' );
  if( parts.length === 2 )
  {
    parts[ 0 ] = parts[ 0 ].trim();
    if( !_.arrayHas( self.Directive, parts[ 0 ] ) )
    return;
    return parts;
  }
}

//

function _directiveApply( directive )
{
  let self = this;
  let handled = 0;
  let name = directive[ 0 ];
  let value = directive[ 1 ];

  if( name === 'inputRaw' )
  {
    self.inputRaw = _.boolFrom( value.trim() );
    return true;
  }

  if( self.inputRaw )
  return;

  if( !self.inputGray )
  {
    if( name === 'foreground' || name === 'fg' )
    {
      self.foregroundColor = value;
      return true;
    }
    else if( name === 'background' || name === 'bg' )
    {
      self.backgroundColor = value;
      return true;
    }
  }

  if( name === 'outputGray' )
  {
    self.outputGray = _.boolFrom( value.trim() );
    return true;
  }
  else if( name === 'inputGray' )
  {
    self.inputGray = _.boolFrom( value.trim() );
    return true;
  }
  else if( name === 'outputRaw' )
  {
    self.outputRaw = _.boolFrom( value.trim() );
    return true;
  }

  // _.assert( 0, 'Unknown logger directive', _.strQuote( name ) );
}

//

function _transformAct( original )
{

  return function _transformAct( o )
  {
    let self = this;

    _.assert( _.mapIs( o ) );

    o = original.call( self,o );

    _.assert( _.strIs( o.pure ) );
    _.assert( _.longIs( o.input ) );
    _.assert( _.longIs( o.outputForPrinter ) );
    _.assert( o.outputForPrinter.length === 1 )
    _.assert( arguments.length === 1, 'expects single argument' );

    if( !self.outputGray && _.color )
    self._transformColor( o );

    self._transformSplit( o ); /* xxx */

    /* */

    if( self.writingToHtml )
    self._transformActHtml( o );
    else if( Config.platform === 'nodejs' )
    self._transformAct_nodejs( o );
    else if( Config.platform === 'browser' )
    self._transformAct_browser( o );

    _.assert( _.arrayIs( o.outputForPrinter ) );

    return o;
  }

}

//

function _rgbToCode_nodejs( rgb, isBackground )
{
  let name = _.color._colorNameNearest( rgb, _.color.ColorMapShell );
  let code = shellColorCodes[ name ];

  _.assert( _.numberIs( code ), 'nothing found for color: ', name );

  if( isBackground )
  code += 10; /* add 10 to convert fg code to bg code */

  return _.toStr( code );
}

//

function _diagnosingColorCheck()
{
  let self = this;

  if( isBrowser )
  return;

  if( !self.foregroundColor || !self.backgroundColor )
  return;

  /* qqq : ??? */

  let stackFg = self._diagnosingColorsStack[ 'foreground' ];
  let stackBg = self._diagnosingColorsStack[ 'background' ];

  let fg = stackFg[ stackFg.length - 1 ];
  let bg = stackBg[ stackBg.length - 1 ];

  /* */

  let result = {};

  if( self.diagnosingColor )
  result.ill = self._diagnosingColorIll( fg, bg );

  if( self.diagnosingColorCollapse )
  result.collapse = self._diagnosingColorCollapse( fg, bg );

  return result;

}

//

function _diagnosingColorIll( fg, bg )
{
  let self = this;
  let ill = false;

  for( let i = 0; i < PoisonedColorCombination.length; i++ )
  {
    let combination = PoisonedColorCombination[ i ];
    if( combination.fg === fg.originalName && combination.bg === bg.originalName )
    // if( combination.platform === process.platform )
    {
      self.diagnosingColor = 0;
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

function _diagnosingColorCollapse( fg, bg )
{
  let self = this;
  let collapse = false;

  if( _.arrayIdentical( self.foregroundColor, self.backgroundColor ) )
  {
    if( fg.originalName !== bg.originalName )
    {
      let diff = _.color._colorDistance( fg.originalValue, bg.originalValue );
      if( diff <= 0.25 )
      collapse = true;
    }
  }

  if( collapse )
  {
    // logger.foregroundColor = 'blue';
    // logger.backgroundColor = 'yellow';
    self.diagnosingColorCollapse = 0;
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
// accessor
// --

function _foregroundColorGet()
{
  let self = this;
  return self[ symbolForForeground ];
}

//

function _backgroundColorGet()
{
  let self = this;
  return self[ symbolForBackground ];
}

//

function _foregroundColorSet( color )
{
  let self = this;
  let layer = 'foreground';

  self._colorSet( layer, color );
}

//

function _backgroundColorSet( color )
{
  let self = this;
  let layer = 'background';

  self._colorSet( layer, color );
}

//

function _colorSet( layer, color )
{
  let self = this;
  let symbol;
  let diagnosticInfo;

  if( layer === 'foreground' )
  symbol = symbolForForeground;
  else if( layer === 'background' )
  symbol = symbolForBackground;
  else _.assert( 0, 'unexpected' );

  if( _.strIs( color ) )
  color = color.trim();

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
    // if( color === 'light green' )
    // debugger;
    let keys = _.mapOwnKeys( map );
    for( let i = 0; i < keys.length; i++ )
    if( _.arrayIdentical( map[ keys[ i ] ], color ) )
    return keys[ i ];

  }

  /* */

  if( color && color !== 'default' )
  {
    let originalName = color;
    if( isBrowser )
    {
      color = _.color.rgbaFromTry( color, null );
    }
    else
    {
      color = _.color.rgbaFromTry.apply( { colorMap :  _.color.ColorMapShell }, [ color, null ] );
      if( !color )
      color = _.color.rgbaFromTry( originalName, null );
    }

    if( !color )
    throw _.err( 'Can\'t set', layer, 'color.', 'Unknown color name:', _.strQuote( originalName ) );

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
        color = _.color.colorNearestCustom({ color : color, colorMap :  _.color.ColorMapShell });
        currentName = _getColorName(  _.color.ColorMapShell, color );
      }

      // console.log( '_colorSet', currentName, colorWas, '->', color );

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

    if( self._diagnosingColorsStack  )
    self._diagnosingColorsStack[ layer ].pop();
  }
  else
  {
    if( self[ symbol ] )
    self._stackPush( layer, self[ symbol ] );

    self[ symbol ] = color;
    self._isStyled = 1;

    if( !self._diagnosingColorsStack  )
    self._diagnosingColorsStack = { 'foreground' : [], 'background' : [] };

    self._diagnosingColorsStack[ layer ].push( diagnosticInfo );
  }

}

//

function styleSet( style )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( style ) );

  if( style === 'default' )
  {
    self.foregroundColor = 'default';
    self.backgroundColor = 'default';
    return;
  }

  let style = _.color.strColorStyle( style );

  if( !style )
  return;

  if( style.fg )
  self.foregroundColor = style.fg;

  if( style.bg )
  self.backgroundColor = style.bg;

}

//

function _inputGraySet( src )
{
  let self = this;
  _.assert( _.boolLike( src ) );

  if( _.boolIs( src ) )
  src = self.inputGray + ( src ? 1 : -1 );

  if( src < 0 )
  debugger;

  if( src < 0 )
  src = 0;

  self[ inputGraySymbol ] = src;

}

//

function _outputGraySet( src )
{
  let self = this;
  _.assert( _.boolLike( src ) );

  if( _.boolIs( src ) )
  src = self.outputGray + ( src ? 1 : -1 );

  if( src < 0 )
  debugger;

  if( src < 0 )
  src = 0;

  self[ outputGraySymbol ] = src;

}

//

function _inputRawSet( src )
{
  let self = this;
  _.assert( _.boolLike( src ) );

  if( _.boolIs( src ) )
  src = self.inputRaw + ( src ? 1 : -1 );

  if( src < 0 )
  debugger;

  if( src < 0 )
  src = 0;

  self[ inputRawSymbol ] = src;

}

//

function _outputRawSet( src )
{
  let self = this;
  _.assert( _.boolLike( src ) );

  if( _.boolIs( src ) )
  src = self.outputRaw + ( src ? 1 : -1 );

  if( src < 0 )
  debugger;

  if( src < 0 )
  src = 0;

  self[ outputRawSymbol ] = src;

}

// --
// string formatters
// --

function colorFormat( src, format )
{
  let self = this;
  _.assert( arguments.length === 2 );
  if( self.outputGray || !_.color || !_.color.strFormat )
  return src;
  return _.color.strFormat( src, format );
}

//

function colorBg( src, format )
{
  let self = this;
  _.assert( arguments.length === 2 );
  if( self.outputGray || !_.color || !_.color.strFormatBackground )
  return src;
  return _.color.strFormatBackground( src, format );
}

//

function colorFg( src, format )
{
  let self = this;
  _.assert( arguments.length === 2 );
  if( self.outputGray || !_.color || !_.color.strFormatForeground )
  return src;
  return _.color.strFormatForeground( src, format );
}

//

function escape( src )
{
  let self = this;
  _.assert( arguments.length === 1 );
  if( /*self.outputGray ||*/ !_.color || !_.color.strFormatForeground )
  return src;
  return _.color.strEscape( src );
}

//

function str()
{
  debugger;
  return _.str.apply( _, arguments );
}

// --
// topic
// --

function topic()
{
  let self = this;

  let result = _.strConcat( arguments );

  if( !self.outputGray )
  result = _.color.strFormat( result, 'topic.up' );

  this.log();
  this.log( result );

  return result;
}

//

function topicUp()
{
  let self = this;

  let result = _.strConcat( arguments );

  if( !self.outputGray )
  result = _.color.strFormat( result, 'topic.up' );

  this.log();
  this.logUp( result );

  return result;
}

//

function topicDown()
{
  let self = this;

  let result = _.strConcat( arguments );

  if( !self.outputGray )
  result = _.color.strFormat( result, 'topic.down' );

  this.log();
  this.logDown( result );
  this.log();

  return result;
}

// --
// fields
// --

let symbolForLevel = Symbol.for( 'level' );
let symbolForForeground = Symbol.for( 'foregroundColor' );
let symbolForBackground = Symbol.for( 'backgroundColor' );

let inputGraySymbol = Symbol.for( 'inputGray' );
let outputGraySymbol = Symbol.for( 'outputGray' );
let inputRawSymbol = Symbol.for( 'inputRaw' );
let outputRawSymbol = Symbol.for( 'outputRaw' );

let shellColorCodes =
{
  'black'           : 30,
  'dark red'        : 31,
  'dark green'      : 32,
  'dark yellow'     : 33,
  'dark blue'       : 34,
  'dark magenta'    : 35,
  'dark cyan'       : 36,
  'dark white'      : 37,

  'bright black'    : 90,
  'red'             : 91,
  'green'           : 92,
  'yellow'          : 93,
  'blue'            : 94,
  'magenta'         : 95,
  'cyan'            : 96,
  'white'           : 97
}

/* let shellColorCodesUnix =
{
  'white'           : 37,
  'light white'     : 97,
} */

let PoisonedColorCombination =
[

  { fg : 'white', bg : 'yellow', platform : 'win32' },
  { fg : 'green', bg : 'cyan', platform : 'win32' },
  { fg : 'red', bg : 'magenta', platform : 'win32' },
  { fg : 'yellow', bg : 'white', platform : 'win32' },
  { fg : 'cyan', bg : 'green', platform : 'win32' },
  { fg : 'cyan', bg : 'yellow', platform : 'win32' },
  { fg : 'magenta', bg : 'red', platform : 'win32' },
  { fg : 'bright black', bg : 'magenta', platform : 'win32' },
  { fg : 'dark yellow', bg : 'magenta', platform : 'win32' },
  { fg : 'dark blue', bg : 'blue', platform : 'win32' },
  { fg : 'dark cyan', bg : 'magenta', platform : 'win32' },
  { fg : 'dark green', bg : 'magenta', platform : 'win32' },
  { fg : 'dark white', bg : 'green', platform : 'win32' },
  { fg : 'dark white', bg : 'cyan', platform : 'win32' },
  { fg : 'green', bg : 'dark white', platform : 'win32' },
  { fg : 'blue', bg : 'dark blue', platform : 'win32' },
  { fg : 'cyan', bg : 'dark white', platform : 'win32' },
  { fg : 'bright black', bg : 'dark yellow', platform : 'win32' },
  { fg : 'bright black', bg : 'dark cyan', platform : 'win32' },
  { fg : 'dark yellow', bg : 'bright black', platform : 'win32' },
  { fg : 'dark yellow', bg : 'dark cyan', platform : 'win32' },
  { fg : 'dark red', bg : 'dark manenta', platform : 'win32' },
  { fg : 'dark magenta', bg : 'dark red', platform : 'win32' },
  { fg : 'dark cyan', bg : 'bright black', platform : 'win32' },
  { fg : 'dark cyan', bg : 'dark yellow', platform : 'win32' },
  { fg : 'dark cyan', bg : 'dark green', platform : 'win32' },
  { fg : 'dark green', bg : 'dark cyan', platform : 'win32' },

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

let Directive = [ 'bg', 'background', 'fg', 'foreground', 'outputGray', 'inputGray', 'inputRaw', 'outputRaw' ];
let DirectiveColoring = [ 'bg', 'background', 'fg', 'foreground' ];

// --
// relationships
// --

let Composes =
{

  foregroundColor : null,
  backgroundColor : null,
  permanentStyle : null,

  coloringHeadAndTail : 1,
  coloringConnotation : 1,
  writingToHtml : 0,

  raw : 0,
  inputGray : 0,
  outputGray : 0,
  inputRaw : 0,
  outputRaw : 0,

}

let Aggregates =
{

}

let Associates =
{

}

let Restricts =
{

  _colorsStack : null,
  _diagnosingColorsStack : null, /* qqq : what for??? */

  _isStyled : 0,
  _cursorSaved : 0,

}

let Statics =
{
  rawAll : 0,
  diagnosingColor : 1, /* xxx */
  diagnosingColorCollapse : 1,
  PoisonedColorCombination : PoisonedColorCombination,
  Directive : Directive,
  DirectiveColoring : DirectiveColoring,
}

let Forbids =
{
  coloring : 'coloring',
  outputColoring : 'outputColoring',
  inputColoring : 'inputColoring',
}

let Accessors =
{

  foregroundColor : 'foregroundColor',
  backgroundColor : 'backgroundColor',

  inputGray : 'inputGray',
  outputGray : 'outputGray',
  inputRaw : 'inputRaw',
  outputRaw : 'outputRaw',

}

// --
// define class
// --

let Functors =
{

  _transformAct : _transformAct,

}

let Extend =
{

  // stack

  _stackPush : _stackPush,
  _stackPop : _stackPop,
  _stackIsNotEmpty : _stackIsNotEmpty,

  // transform

  _transformActHtml : _transformActHtml,
  _transformAct_nodejs : _transformAct_nodejs,
  _transformAct_browser : _transformAct_browser,
  _transformActWithoutColors : _transformActWithoutColors,
  _transformColor : _transformColor,
  _transformSplit : _transformSplit,

  //

  _join : _join,
  _split : _split,
  _splitHandle : _splitHandle,
  _directiveApply : _directiveApply,

  _rgbToCode_nodejs : _rgbToCode_nodejs,
  _diagnosingColorCheck : _diagnosingColorCheck,
  _diagnosingColorIll : _diagnosingColorIll,
  _diagnosingColorCollapse : _diagnosingColorCollapse,

  // accessor

  _foregroundColorGet : _foregroundColorGet,
  _backgroundColorGet : _backgroundColorGet,
  _foregroundColorSet : _foregroundColorSet,
  _backgroundColorSet : _backgroundColorSet,
  _colorSet : _colorSet,
  styleSet : styleSet,

  _inputGraySet : _inputGraySet,
  _outputGraySet : _outputGraySet,
  _inputRawSet : _inputRawSet,
  _outputRawSet : _outputRawSet,

  // string formatters

  colorFormat : colorFormat,
  colorBg : colorBg,
  colorFg : colorFg,
  escape : escape,
  str : str,

  // topic

  topic : topic,
  topicUp : topicUp,
  topicDown : topicDown,

  // relationships

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,
  Accessors : Accessors,

}

//

_.classMake
({
  cls : Self,
  extend : Extend,
  functors : Functors,
  withMixin : true,
  withClass : true,
});

// --
// export
// --

_[ Self.nameShort ] = Self;

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();

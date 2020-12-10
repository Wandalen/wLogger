# Entities
Overview of the entities presented in the module.

### Class LoggerBasic
Class with basic abilities of the printer: input transformation, verbosity level change.

### Class Chainer
Class that encapsulates chainability of printers, loggers and consoles.
Several printerLike entities ( console, stream, process ) can be chained together, modifying and transfering data.

### Class ChainDescriptor
Class that connects two printerLike entities.

### Class PrinterChainingMixin
Class that extends printer with mechanism of message transfering between multiple inputs/outputs.
Several printers can be chained together, modifying and transfering data.

### Class PrinterColoredMixin
Class that extends printer with mechanism of message coloring.

### Class LoggerMid
Class that extends logger with input transforming, attributing and verbosity control mechanics. Parent : LoggerBasic

### Class Logger
Class that creates a logger for printing colorful and well formatted diagnostic code. Parent : LoggerMid.

### Class LoggerPrime
Class that creates a logger for printing colorful and well formatted diagnostic code. Parent : Logger

### Class PrinterToLayeredHtml
Class that creates a printer that writes messages into a DOM container. Parent : Logger.

### Class LoggerToString
Class that creates a printer that collects messages into a single string. Parent : LoggerMid.


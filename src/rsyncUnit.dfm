object rsync: Trsync
  Left = 333
  Top = 511
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Data Transfer in Progress...'
  ClientHeight = 286
  ClientWidth = 543
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 18
  object ProgressLabel: TLabel
    Left = 16
    Top = 248
    Width = 74
    Height = 18
    Caption = 'File Progress:'
  end
  object FilesRemainingLabelLabel: TLabel
    Left = 19
    Top = 40
    Width = 102
    Height = 16
    Caption = 'Files Remaining:'
    Font.Charset = ANSI_CHARSET
    Font.Color = cl3DDkShadow
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedLabelLabel: TLabel
    Left = 216
    Top = 40
    Width = 45
    Height = 16
    Caption = 'Speed:'
    Font.Charset = ANSI_CHARSET
    Font.Color = cl3DDkShadow
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lvTransfers: TListView
    Left = 16
    Top = 64
    Width = 513
    Height = 169
    Columns = <
      item
        Caption = 'Filename'
        Width = 368
      end
      item
        Alignment = taRightJustify
        Caption = 'Bytes'
        Width = 65
      end
      item
        Alignment = taRightJustify
        Caption = 'Time left'
        Width = 61
      end>
    ColumnClick = False
    Items.Data = {
      330000000100000000000000FFFFFFFFFFFFFFFF020000000000000004546573
      7404313233340830303A30303A3030FFFFFFFF}
    TabOrder = 6
    ViewStyle = vsReport
  end
  object captureOutput: TMemo
    Left = 14
    Top = 288
    Width = 515
    Height = 97
    Hint = 'This is the output from the backup program.'
    Color = clNone
    Font.Charset = OEM_CHARSET
    Font.Color = clSilver
    Font.Height = -8
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ScrollBars = ssVertical
    ShowHint = True
    TabOrder = 0
  end
  object closeButton: TBitBtn
    Left = 456
    Top = 240
    Width = 73
    Height = 33
    Enabled = False
    TabOrder = 1
    OnClick = closeButtonClick
    Kind = bkClose
  end
  object ProgressBar: TProgressBar
    Left = 96
    Top = 248
    Width = 273
    Height = 17
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 2
  end
  object cancelButton: TBitBtn
    Left = 376
    Top = 240
    Width = 73
    Height = 33
    TabOrder = 3
    OnClick = cancelButtonClick
    Kind = bkCancel
  end
  object FilesRemainingLabel: TStaticText
    Left = 125
    Top = 40
    Width = 81
    Height = 22
    AutoSize = False
    Caption = '2983497'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object SpeedLabel: TStaticText
    Left = 264
    Top = 40
    Width = 67
    Height = 22
    AutoSize = False
    Caption = '390 k/sec'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object Status: TStaticText
    Left = 16
    Top = 8
    Width = 497
    Height = 28
    AutoSize = False
    Caption = 'Status'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object regexProgress: TPcreRegExp
    Left = 32
    Top = 304
  end
end

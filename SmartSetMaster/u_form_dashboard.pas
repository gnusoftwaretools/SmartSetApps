unit u_form_dashboard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  HSSpeedButton, LineObj, ColorSpeedButton, BGRASpriteAnimation, u_const,
  LResources, FileUtil, u_kinesis_device, u_form_main_rgb, LCLIntf,
  u_form_loading, u_form_about_master, eject_usb, u_form_settings_master,
  u_form_firmware, userdialog, u_common_ui, u_form_main_tko
  {$ifdef Win32},Windows{$endif};

type

  { TFormDashboard }

  TFormDashboard = class(TForm)
    btnCheckUpdatesConnected2: TColorSpeedButton;
    btnCheckUpdatesConnected3: TColorSpeedButton;
    btnCheckUpdatesConnected4: TColorSpeedButton;
    btnEject2: TColorSpeedButton;
    btnEject3: TColorSpeedButton;
    btnEject4: TColorSpeedButton;
    btnOpenApp1: TColorSpeedButton;
    btnOpenApp2: TColorSpeedButton;
    btnOpenApp3: TColorSpeedButton;
    btnOpenApp4: TColorSpeedButton;
    btnWatchTutorial2: TColorSpeedButton;
    btnWatchTutorial3: TColorSpeedButton;
    btnWatchTutorial4: TColorSpeedButton;
    imgAppLogo1: TImage;
    imgAppLogo2: TImage;
    lblAppName2: TLabel;
    lblAppName3: TLabel;
    lblAppName4: TLabel;
    lblConnApp2: TLabel;
    lblConnApp3: TLabel;
    lblConnApp4: TLabel;
    lblDemoMode: TLabel;
    lblHelp: TLabel;
    btnEject1: TColorSpeedButton;
    btnWatchTutorial1: TColorSpeedButton;
    btnClose: THSSpeedButton;
    btnMaximize: THSSpeedButton;
    btnMinimize: THSSpeedButton;
    btnCheckUpdatesConnected1: TColorSpeedButton;
    imgApp1: TImage;
    imgApp2: TImage;
    imgApp3: TImage;
    imgApp4: TImage;
    imgMain: TImage;
    imgListMenu: TImageList;
    imgLogo: TImage;
    imgSmartSetLogo: TImage;
    lblHome: TLabel;
    lblProfileApp2: TLabel;
    lblProfileApp3: TLabel;
    lblProfileApp4: TLabel;
    lblSettings: TLabel;
    Label3: TLabel;
    lblAppName1: TLabel;
    lblConnApp1: TLabel;
    lblProfileApp1: TLabel;
    lblVDriveError: TLabel;
    lblVDriveOk: TLabel;
    lineBorderLeftTop: TLineObj;
    lineBorderRightTop: TLineObj;
    pnlApp1: TPanel;
    pnlApp2: TPanel;
    pnlApp3: TPanel;
    pnlApp4: TPanel;
    pnlMain: TPanel;
    pnlTop: TPanel;
    tmrCheckConnected: TTimer;
    tmrLoadForms: TTimer;
    procedure btnCheckUpdatesConnectedClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEjectClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure btnOpenAppClick(Sender: TObject);
    procedure btnWatchTutorialClick(Sender: TObject);
    procedure ButtonMouseEnter(Sender: TObject);
    procedure ButtonMouseLeave(Sender: TObject);
    procedure ButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure imgLogoClick(Sender: TObject);
    procedure lblHomeClick(Sender: TObject);
    procedure lblHelpClick(Sender: TObject);
    procedure lblSettingsClick(Sender: TObject);
    procedure tmrCheckConnectedTimer(Sender: TObject);
    procedure tmrLoadFormsTimer(Sender: TObject);
    procedure TopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TopMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
  private
    fontColor: TColor;
    backColor: TColor;
    blueColor: TColor;
    gamingMode: boolean;
    cusWindowState: TCusWinState;
    deviceList: TDeviceList;
    procedure AddDevices;
    procedure EnablePaintImages(value: boolean);
    procedure GetAppObjects(idx: integer; var appNameLabel: TLabel;
      var appConnLabel: TLabel; var appProfileLabel: TLabel;  var appCheckUpdBtn: TColorSpeedButton;
      var appEjectBtn: TColorSpeedButton; var appWatchTutoBtn: TColorSpeedButton; var appOpenBtn: TColorSpeedButton);
    procedure Init;
    procedure RepaintForm(fullRepaint: boolean);
    procedure RepositionItems(pnlApp: TPanel; btnCheckUpdates: TColorSpeedButton;
      btnEject: TColorSpeedButton; btnWatchTutorial: TColorSpeedButton);
    procedure SetFormBorder(formBorder: TFormBorderStyle);
    procedure UpdateDevices;
    procedure UpdateStateSettings;
    procedure OpenDeviceForm(device: TDevice);
    procedure LoadAppForms;
    procedure CloseActiveForms;
    procedure ResetToHome;
  public

  end;

var
  FormDashboard: TFormDashboard;
  MPos:TPoint; {Position of the Form before drag}
  procedure SetVDriveState(state: boolean);

const
  MAX_DEVICES = 2;
  MM_MAX_NUMAXES = 16;
  NORMAL_HEIGHT = 850;
  NORMAL_WIDTH = 1550;
  MAX_HEIGHT = 1000;
  MAX_WIDTH = 1875;
  CONN_TEXT = 'Connected';
  NOT_DETECT_TEXT = 'Not Detected';
  CONN_COLOR = clLime;
  NOT_DETECT_COLOR = clRed;


implementation

{$R *.lfm}

procedure SetVDriveState(state: boolean);
begin
  if not(GDemoMode) then
  begin
    FormDashboard.lblVDriveOk.Visible := state;
    FormDashboard.lblVDriveError.Visible := not state;
  end;
end;

{ TFormDashboard }

procedure TFormDashboard.FormCreate(Sender: TObject);
//var
//  vFnt : THandle;
begin
  SetFormBorder(bsNone);
  self.Width := NORMAL_WIDTH;
  self.Height := NORMAL_HEIGHT;
  cusWindowState := cwNormal;
  deviceList := TDeviceList.Create;

  //Load front from ressource
  LoadFontFromRes('Quantify');
  //vFnt := LoadFontFromRes('Quantify');
  //SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  //Application.ProcessMessages;

  //Fonts
  SetFont(self, 'Tahoma');
  lblAppName1.Font.Name := 'Quantify';
  lblAppName2.Font.Name := 'Quantify';
  lblAppName3.Font.Name := 'Quantify';
  lblAppName4.Font.Name := 'Quantify';

  //App shows in Taskbar only when minimized
  Application.MainFormOnTaskBar:= true;

  AddDevices;

  gamingMode := true;
  Init;
end;

procedure TFormDashboard.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if (CloseAction = caFree) then
  begin
    ResetToHome;
    FreeAndNil(deviceList);
  end;
end;

procedure TFormDashboard.FormDestroy(Sender: TObject);
begin
  FreeAndNil(deviceList);
end;

procedure TFormDashboard.FormResize(Sender: TObject);
begin
  RepositionItems(pnlApp1, btnCheckUpdatesConnected1, btnEject1, btnWatchTutorial1);
  RepositionItems(pnlApp2, btnCheckUpdatesConnected2, btnEject2, btnWatchTutorial2);
  RepositionItems(pnlApp3, btnCheckUpdatesConnected3, btnEject3, btnWatchTutorial3);
  RepositionItems(pnlApp4, btnCheckUpdatesConnected4, btnEject4, btnWatchTutorial4);
end;

procedure TFormDashboard.RepositionItems(pnlApp: TPanel; btnCheckUpdates: TColorSpeedButton; btnEject: TColorSpeedButton;
  btnWatchTutorial: TColorSpeedButton);
begin
  btnCheckUpdates.Left := pnlApp.Left;
  btnCheckUpdates.Top := pnlApp.Top + pnlApp.Height + 10;
  btnWatchTutorial.Left := (pnlApp.Left + pnlApp.Width) - btnWatchTutorial.Width;
  btnWatchTutorial.Top := btnCheckUpdates.Top;
  btnEject.Left := (pnlApp.Left + (pnlApp.Width div 2) - (btnEject.Width div 2));
  btnEject.Top :=  btnCheckUpdates.Top;
end;

procedure TFormDashboard.Init;
begin
  //Set colors also check if DarkTheme is enabled on OS
  blueColor := KINESIS_BLUE;
  if (gamingMode or IsDarkTheme) then
  begin
    fontColor := clWhite;
    backColor := KINESIS_DARK_GRAY_FS;
  end
  else
  begin
    fontColor := clBlack;
    backColor := clWhite;

    pnlTop.Color := backColor;
    btnMinimize.Color := backColor;
    btnMinimize.HotTrackColor := backColor;
    btnMinimize.LightColor := backColor;
    btnMinimize.ShadowColor := backColor;
    btnMinimize.TransparentColor := backColor;
    btnMaximize.Color := backColor;
    btnMaximize.HotTrackColor := backColor;
    btnMaximize.LightColor := backColor;
    btnMaximize.ShadowColor := backColor;
    btnMaximize.TransparentColor := backColor;
    btnClose.Color := backColor;
    btnClose.HotTrackColor := backColor;
    btnClose.LightColor := backColor;
    btnClose.ShadowColor := backColor;
    btnClose.TransparentColor := backColor;

    imgListMenu.GetBitmap(0, btnMinimize.Glyph);
    imgListMenu.GetBitmap(4, btnClose.Glyph);
    imgListMenu.GetBitmap(1, btnMaximize.Glyph);
  end;

  UpdateDevices;
  tmrCheckConnected.Enabled := true;
  tmrLoadForms.Enabled := true;
end;

//Add list of devices
procedure TFormDashboard.AddDevices;
var
  aDevice: TDevice;
begin
  aDevice := TDevice.Create;
  aDevice.DeviceName := 'FREESTYLE EDGE RGB';
  aDevice.DeviceNumber := APPL_RGB;
  aDevice.VDriveName := RGB_DRIVE;
  aDevice.TutorialUrl := RGB_TUTORIAL;
  aDevice.ScanVDriveHint := 'To program the keyboard, you must first connect the v-Drive to the PC using the shortcut SmartSet + F8';
  deviceList.Add(aDevice);

  aDevice := TDevice.Create;
  aDevice.DeviceName := 'TKO';
  aDevice.DeviceNumber := APPL_TKO;
  aDevice.VDriveName := TKO_DRIVE;
  aDevice.TutorialUrl := TKO_TUTORIAL;
  aDevice.ScanVDriveHint := 'To program the keyboard, you must first connect the v-Drive to the PC using the shortcut SmartSet + Right Shift + V';
  deviceList.Add(aDevice);

  //aDevice := TDevice.Create;
  //aDevice.DeviceName := 'CROSSFIRE KEYPAD';
  //aDevice.DeviceNumber := APPL_CROSSKP;
  //aDevice.VDriveName := CROSSKP_DRIVE;
  //aDevice.FutureDevice := true;
  //aDevice.TutorialUrl := '';
  //deviceList.Add(aDevice);
  //
  //aDevice := TDevice.Create;
  //aDevice.DeviceName := 'TKO';
  //aDevice.DeviceNumber := APPL_TKO;
  //aDevice.VDriveName := TKO_DRIVE;
  //aDevice.FutureDevice := true;
  //aDevice.TutorialUrl := '';
  //deviceList.Add(aDevice);
  //
  //aDevice := TDevice.Create;
  //aDevice.DeviceName := 'FREESTYLE EDGE';
  //aDevice.DeviceNumber := APPL_FSEDGE;
  //aDevice.VDriveName := FSEDGE_DRIVE;
  //aDevice.TutorialUrl := FSEDGE_TUTORIAL;
  //deviceList.Add(aDevice);
end;

procedure TFormDashboard.UpdateDevices;
var
  aDevice: TDevice;
  appNameLabel: TLabel;
  appConnLabel: TLabel;
  appProfileLabel: TLabel;
  appCheckUpdBtn: TColorSpeedButton;
  appEjectBtn: TColorSpeedButton;
  appOpenBtn: TColorSpeedButton;
  appWatchTutoBtn: TColorSpeedButton;
  idx: integer;
begin
  for idx := 1 to MAX_DEVICES do
  begin
    aDevice := nil;
    if (deviceList.Count >= idx) then
      aDevice := deviceList.Items[idx - 1];

    //Init objects
    appNameLabel := nil;
    appConnLabel := nil;
    appProfileLabel := nil;
    appCheckUpdBtn := nil;
    appEjectBtn := nil;
    appWatchTutoBtn := nil;
    appOpenBtn := nil;

    //Get objets by app index
    GetAppObjects(idx, appNameLabel, appConnLabel, appProfileLabel, appCheckUpdBtn, appEjectBtn, appWatchTutoBtn, appOpenBtn);

    appNameLabel.Caption := '';
    appConnLabel.Caption := '';
    appProfileLabel.Caption := '';
    appOpenBtn.Caption := 'Demo Mode';
    appEjectBtn.Visible := false;
    appCheckUpdBtn.Caption := 'Scan for v-Drive';
    appCheckUpdBtn.Hint := aDevice.ScanVDriveHint;

    if (aDevice <> nil) then
    begin
      //Gets device info
      GetDeviceInformation(aDevice);

      appNameLabel.Caption := aDevice.DeviceName;
      if (aDevice.FutureDevice) then
      begin
        appOpenBtn.Caption := 'Learn More';
        appConnLabel.Caption := 'Coming Soon';
        appConnLabel.Font.Color := clRed;
        appCheckUpdBtn.Visible := false;
        appEjectBtn.Visible := false;
        appWatchTutoBtn.Visible := false;
      end
      else if (aDevice.Connected) then
      begin
        appConnLabel.Caption := CONN_TEXT;
        appConnLabel.Font.Color := CONN_COLOR;
        appOpenBtn.Caption := 'Configure';
        appProfileLabel.Caption := 'Profile ' + fileService.GetStartupFileNo(aDevice);
        appEjectBtn.Visible := true;
        appCheckUpdBtn.Caption := 'Check for Updates';
        appCheckUpdBtn.Hint := '';
      end
      else
      begin
        appConnLabel.Caption := NOT_DETECT_TEXT;
        appConnLabel.Font.Color := NOT_DETECT_COLOR;
      end;
    end;
  end;
end;

procedure TFormDashboard.GetAppObjects(idx: integer; var appNameLabel: TLabel;
  var appConnLabel: TLabel; var appProfileLabel: TLabel; var appCheckUpdBtn: TColorSpeedButton;
  var appEjectBtn: TColorSpeedButton; var appWatchTutoBtn: TColorSpeedButton; var appOpenBtn: TColorSpeedButton);
begin
  if (idx = 1) then
  begin
    appNameLabel := lblAppName1;
    appConnLabel := lblConnApp1;
    appProfileLabel := lblProfileApp1;
    appCheckUpdBtn := btnCheckUpdatesConnected1;
    appEjectBtn := btnEject1;
    appWatchTutoBtn := btnWatchTutorial1;
    appOpenBtn := btnOpenApp1;
  end
  else if (idx = 2) then
  begin
    appNameLabel := lblAppName2;
    appConnLabel := lblConnApp2;
    appProfileLabel := lblProfileApp2;
    appCheckUpdBtn := btnCheckUpdatesConnected2;
    appEjectBtn := btnEject2;
    appWatchTutoBtn := btnWatchTutorial2;
    appOpenBtn := btnOpenApp2;
  end
  else if (idx = 3) then
  begin
    appNameLabel := lblAppName3;
    appConnLabel := lblConnApp3;
    appProfileLabel := lblProfileApp3;
    appCheckUpdBtn := btnCheckUpdatesConnected3;
    appEjectBtn := btnEject3;
    appWatchTutoBtn := btnWatchTutorial3;
    appOpenBtn := btnOpenApp3;
  end
  else if (idx = 4) then
  begin
    appNameLabel := lblAppName4;
    appConnLabel := lblConnApp4;
    appProfileLabel := lblProfileApp4;
    appCheckUpdBtn := btnCheckUpdatesConnected4;
    appEjectBtn := btnEject4;
    appWatchTutoBtn := btnWatchTutorial4;
    appOpenBtn := btnOpenApp4;
  end;
end;

procedure TFormDashboard.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormDashboard.btnEjectClick(Sender: TObject);
var
  idx: integer;
  device: TDevice;
  button: TColorSpeedButton;
begin
  idx := 0;
  button := (sender as TColorSpeedButton);

  try
    Screen.Cursor := crHourGlass;
    button.Enabled := false;

    if (button = btnEject1) then
      idx := 1
    else if (button = btnEject2) then
      idx := 2
    else if (button = btnEject3) then
      idx := 3
    else if (button = btnEject4) then
      idx := 4;

    if (idx > 0) and (deviceList.Count >= 1) then
    begin
      device := deviceList.Items[idx - 1];
      if EjectDevice(device) then
        UpdateDevices;
    end;
  finally
    button.Enabled := true;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDashboard.btnCheckUpdatesConnectedClick(Sender: TObject);
var
  idx: integer;
  device: TDevice;
  button: TColorSpeedButton;
begin
  idx := 0;
  button := (sender as TColorSpeedButton);

  try
    Screen.Cursor := crHourGlass;
    button.Enabled := false;

    if (button = btnCheckUpdatesConnected1) then
      idx := 1
    else if (button = btnCheckUpdatesConnected2) then
      idx := 2
    else if (button = btnCheckUpdatesConnected3) then
      idx := 3
    else if (button = btnCheckUpdatesConnected4) then
      idx := 4;

    if (idx > 0) and (deviceList.Count >= 1) then
    begin
      device := deviceList.Items[idx - 1];
      if (device.Connected) then
      begin
        ShowFirmware(device);
      end
      else
      begin
        UpdateDevices;
      end;
    end;
  finally
    button.Enabled := true;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDashboard.LoadAppForms;
begin
  Application.CreateForm(TFormMainRGB, FormMainRGB);
  FormMainRGB.Parent := pnlMain;

  Application.CreateForm(TFormMainTKO, FormMainTKO);
  FormMainTKO.Parent := pnlMain;
end;

procedure TFormDashboard.CloseActiveForms;
begin
  if (FormMainRGB <> nil) and (FormMainRGB.Visible = true) then
  begin
    FormMainRGB.Close;
  end;
    if (FormMainTKO <> nil) and (FormMainTKO.Visible = true) then
  begin
    FormMainTKO.Close;
  end;
end;

procedure TFormDashboard.btnWatchTutorialClick(Sender: TObject);
var
  idx: integer;
  device: TDevice;
  button: TColorSpeedButton;
begin
  idx := 0;
  button := (sender as TColorSpeedButton);

  try
    Screen.Cursor := crHourGlass;
    button.Enabled := false;

    if (button = btnWatchTutorial1) then
      idx := 1
    else if (button = btnWatchTutorial2) then
      idx := 2
    else if (button = btnWatchTutorial3) then
      idx := 3
    else if (button = btnWatchTutorial4) then
      idx := 4;

    if (idx > 0) and (deviceList.Count >= 1) then
    begin
      device := deviceList.Items[idx - 1];
      if (device.TutorialUrl <> '') then
        OpenUrl(device.TutorialUrl);
    end;
  finally
    button.Enabled := true;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDashboard.btnOpenAppClick(Sender: TObject);
var
  idx: integer;
  device: TDevice;
  button: TColorSpeedButton;
begin
  idx := 0;
  button := (sender as TColorSpeedButton);

  try
    Screen.Cursor := crHourGlass;
    button.Enabled := false;

    if (button = btnOpenApp1) then
      idx := 1
    else if (button = btnOpenApp2) then
      idx := 2
    else if (button = btnOpenApp3) then
      idx := 3
    else if (button = btnOpenApp4) then
      idx := 4;

    if (idx > 0) and (deviceList.Count >= 1) then
    begin
      device := deviceList.Items[idx - 1];

      if (device.FutureDevice) then
      begin

      end
      else
        OpenDeviceForm(device);
    end;
  finally
    button.Enabled := true;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDashboard.OpenDeviceForm(device: TDevice);
begin
  if (device <> nil) then
  begin
    GDemoMode := not(device.Connected);
    GApplication := device.DeviceNumber;

    if (device.DeviceNumber = APPL_RGB) then
    begin
      try
        GActiveDevice := device;
        ShowLoading('Loading...', 'Loading FREESTYLE EDGE RGB...');
        FormMainRGB.InitForm(self);
        FormMainRGB.Show;
        lblDemoMode.Visible := GDemoMode;
        imgAppLogo1.Visible := true;
      finally
        CloseLoading;
      end;
    end
    else if (device.DeviceNumber = APPL_TKO) then
    begin
      try
        GActiveDevice := device;
        ShowLoading('Loading...', 'Loading TKO...');
        FormMainTKO.InitForm(self);
        FormMainTKO.Show;
        lblDemoMode.Visible := GDemoMode;
        imgAppLogo2.Visible := true;
      finally
        CloseLoading;
      end;
    end;
  end;
end;

procedure TFormDashboard.btnMaximizeClick(Sender: TObject);
var
  aRect: TRect;
begin
  aRect := Screen.PrimaryMonitor.WorkareaRect;

  if (cusWindowState = cwMaximized) then
  begin
    self.Height := NORMAL_HEIGHT;
    self.Width := NORMAL_WIDTH;
    self.Left := (aRect.Width - NORMAL_WIDTH) div 2;
    self.Top := (aRect.Height - NORMAL_HEIGHT) div 2;
    cusWindowState := cwNormal;
  end
  else
  begin
    self.Left := aRect.Left;
    self.Top := aRect.Top;
    self.Width := aRect.Width;
    self.Height := aRect.Height;
    cusWindowState := cwMaximized;
  end;

  if (FormMainRGB <> nil) and (FormMainRGB.Visible) then
     FormMainRGB.Maximize;
  if (FormMainTKO <> nil) and (FormMainTKO.Visible) then
     FormMainTKO.Maximize;

  UpdateStateSettings;
end;

procedure TFormDashboard.btnMinimizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TFormDashboard.UpdateStateSettings;
begin
  self.DisableAlign;

  {$ifdef Win32}
  //Disable paint on form
  SendMessage(self.Handle, WM_SETREDRAW, Integer(False), 0);
  {$endif}

  if (cusWindowState = cwMaximized) then
  begin
    if (IsDarkTheme or gamingMode) then
      imgListMenu.GetBitmap(7, btnMaximize.Glyph)
    else
      imgListMenu.GetBitmap(2, btnMaximize.Glyph);
    btnMaximize.Hint := 'Restore window';
  end
  else
  begin
    if (IsDarkTheme or gamingMode) then
      imgListMenu.GetBitmap(6, btnMaximize.Glyph)
    else
      imgListMenu.GetBitmap(1, btnMaximize.Glyph);
    btnMaximize.Hint := 'Maximize';
  end;

  {$ifdef Win32}
  //Enable paint on form on repaint
  SendMessage(self.Handle, WM_SETREDRAW, Integer(True), 0);
  {$endif}

  self.EnableAlign;
  self.Repaint;
end;

procedure TFormDashboard.FormWindowStateChange(Sender: TObject);
begin
  //UpdateStateSettings;
end;

procedure TFormDashboard.imgLogoClick(Sender: TObject);
begin
  OpenURL(KINESIS_GAMING_URL);
end;

procedure TFormDashboard.lblHomeClick(Sender: TObject);
begin
  ResetToHome;
end;

procedure TFormDashboard.ResetToHome;
begin
  //Hide logos
  imgAppLogo1.Visible := false;
  imgAppLogo2.Visible := false;

  lblDemoMode.Visible := false;
  lblVDriveOk.Visible := false;
  lblVDriveError.Visible := false;
  CloseActiveForms;
  if (not GDemoMode) then
    EjectDevice(GActiveDevice);
  GActiveDevice := nil;
  tmrLoadForms.Enabled := true;

  UpdateDevices;
end;

procedure TFormDashboard.lblHelpClick(Sender: TObject);
begin
  try
    NeedInput := true;
    Application.CreateForm(TFormAboutMaster, FormAboutMaster);
    FormAboutMaster.ShowModal;
    FreeAndNil(FormAboutMaster);
  finally
    NeedInput := false;
  end;
end;

procedure TFormDashboard.lblSettingsClick(Sender: TObject);
begin
    try
    NeedInput := true;
    Application.CreateForm(TFormSettingsMaster, FormSettingsMaster);
    FormSettingsMaster.ShowModal;
    FreeAndNil(FormSettingsMaster);
  finally
    NeedInput := false;
  end;
end;

procedure TFormDashboard.tmrCheckConnectedTimer(Sender: TObject);
begin
  tmrCheckConnected.Enabled := false;
  UpdateDevices;
  tmrCheckConnected.Enabled := true;
end;

procedure TFormDashboard.tmrLoadFormsTimer(Sender: TObject);
begin
  //Do only once, load application forms
  tmrLoadForms.Enabled := false;
  LoadAppForms;
end;

procedure TFormDashboard.TopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MPos.X := X;
  MPos.Y := Y;
end;

procedure TFormDashboard.TopMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
  begin
    self.Left := self.Left - (MPos.X-X);
    self.Top := self.Top - (MPos.Y-Y);
  end;
end;

procedure TFormDashboard.SetFormBorder(formBorder: TFormBorderStyle);
begin
  self.BorderStyle := formBorder;
  RepaintForm(true);
end;

procedure TFormDashboard.RepaintForm(fullRepaint: boolean);
var
   region: TRect;
begin
  //Do a form repaint
  try
    EnablePaintImages(false);

    if (fullRepaint) then
      Repaint  //Invalidate;
    else
    begin
      region := TRect.Create(self.Left, self.Top, self.Left + self.Width, self.Top + self.Height);
      InvalidateRect(Handle, @region, false);
    end;
  finally
    EnablePaintImages(true);
  end;
end;

procedure TFormDashboard.EnablePaintImages(value: boolean);
begin
  //Enable/Disable visual effects on controls
  {$ifdef Win32}
  SendMessage(imgMain.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  {$endif}
  {$ifdef Darwin}

  {$endif}
end;

procedure TFormDashboard.ButtonMouseEnter(Sender: TObject);
begin
 (Sender as TColorSpeedButton).Font.Color := blueColor;
end;

procedure TFormDashboard.ButtonMouseLeave(Sender: TObject);
begin
     (Sender as TColorSpeedButton).Font.Color := fontColor;
end;

procedure TFormDashboard.ButtonMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
     (Sender as TColorSpeedButton).Font.Color := blueColor;
end;

initialization
  {$R FONTS.RES}

end.

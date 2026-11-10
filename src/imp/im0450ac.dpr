program im0450ac;

uses
  Forms,
  geradados in 'geradados.pas' {FrmDecl_Imp};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmDecl_Imp, FrmDecl_Imp);
  Application.Run;
end.

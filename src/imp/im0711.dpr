program Prj_Declaracao;

uses
  Forms,
  UntDecl in 'UntDecl.pas' {FrmDecl_Imp};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmDecl_Imp, FrmDecl_Imp);
  Application.Run;
end.

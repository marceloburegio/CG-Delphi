unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, ExtCtrls, Global;

type
  TFormPrincipal = class(TForm)
    BtNegativo: TButton;
    BtSobre: TButton;
    BtFiltros: TButton;
    BtOperacoes: TButton;
    BtArnold: TButton;
    BtGamma: TButton;
    BtHitograma: TButton;
    BtPseudocor: TButton;
    procedure BtPseudocorClick(Sender: TObject);
    procedure BtHitogramaClick(Sender: TObject);
    procedure BtGammaClick(Sender: TObject);
    procedure BtArnoldClick(Sender: TObject);
    procedure BtOperacoesClick(Sender: TObject);
    procedure BtFiltrosClick(Sender: TObject);
    procedure BtSobreClick(Sender: TObject);
    procedure BtNegativoClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses Negativo, Filtros, Operacoes, Arnold, Gamma, Histograma, Pseudocor, Sobre;
{$R *.dfm}

procedure TFormPrincipal.BtNegativoClick(Sender: TObject);
begin
  Application.CreateForm(TFormNegativo, FormNegativo);
  FormNegativo.ShowModal;
  FormNegativo.Free;
end;

procedure TFormPrincipal.BtFiltrosClick(Sender: TObject);
begin
  Application.CreateForm(TFormFiltros, FormFiltros);
  FormFiltros.ShowModal;
  FormFiltros.Free;
end;

procedure TFormPrincipal.BtOperacoesClick(Sender: TObject);
begin
  Application.CreateForm(TFormOperacoes, FormOperacoes);
  FormOperacoes.ShowModal;
  FormOperacoes.Free;
end;

procedure TFormPrincipal.BtSobreClick(Sender: TObject);
begin
  Application.CreateForm(TFormSobre, FormSobre);
  FormSobre.ShowModal;
  FormSobre.Free;
end;

procedure TFormPrincipal.BtArnoldClick(Sender: TObject);
begin
  Application.CreateForm(TFormArnold, FormArnold);
  FormArnold.ShowModal;
  FormArnold.Free;
end;

procedure TFormPrincipal.BtGammaClick(Sender: TObject);
begin
  Application.CreateForm(TFormGamma, FormGamma);
  FormGamma.ShowModal;
  FormGamma.Free;
end;

procedure TFormPrincipal.BtHitogramaClick(Sender: TObject);
begin
  Application.CreateForm(TFormHistograma, FormHistograma);
  FormHistograma.ShowModal;
  FormHistograma.Free;
end;

procedure TFormPrincipal.BtPseudocorClick(Sender: TObject);
begin
  Application.CreateForm(TFormPseudocor, FormPseudocor);
  FormPseudocor.ShowModal;
  FormPseudocor.Free;
end;

end.

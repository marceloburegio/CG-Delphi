unit Gamma;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Math, Global;

type
  TFormGamma = class(TForm)
    LNegativo: TLabel;
    Label1: TLabel;
    BtAbrirImagem: TButton;
    BtVisualizarCorrecao: TButton;
    GroupBox2: TGroupBox;
    Imagem1: TImage;
    GroupBox1: TGroupBox;
    Imagem2: TImage;
    OpenDialogImage: TOpenDialog;
    LbC: TLabel;
    TxC: TEdit;
    TxGamma: TEdit;
    Label2: TLabel;
    procedure BtVisualizarCorrecaoClick(Sender: TObject);
    procedure BtAbrirImagemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormGamma: TFormGamma;
  ImagemPGM1: ImagemPGM;

implementation

{$R *.dfm}

procedure TFormGamma.BtAbrirImagemClick(Sender: TObject);
begin
  if OpenDialogImage.Execute
  then
  begin
    ImagemPGM1 := AbrirImagem(OpenDialogImage.FileName);
    LimparImagem(Imagem1);
    DesenharImagem(ImagemPGM1, Imagem1);
  end;
end;

procedure TFormGamma.BtVisualizarCorrecaoClick(Sender: TObject);
var
  C, Gamma : real;
  ImagemPGM2: ImagemPGM;
begin

  // Obtendo os valores informados de C e Gamma
  C := StrToFloat(TxC.Text);
  Gamma := StrToFloat(TxGamma.Text);
  
  if (C < 0) or (Gamma < 0) then
  begin
    Application.MessageBox('Os valores informados não podem ser negativos.', 'ATENÇÃO', MB_OK);
    Exit;
  end;

  // Aplicando a Transformação de Arnold
  ImagemPGM2 := AplicarGama(ImagemPGM1, C, Gamma);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM2, Imagem2);
end;

end.

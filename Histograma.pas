unit Histograma;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Global;

type
  TFormHistograma = class(TForm)
    LNegativo: TLabel;
    Label1: TLabel;
    BtAbrirImagem: TButton;
    BtEqualizarHistograma: TButton;
    GroupBox2: TGroupBox;
    Imagem1: TImage;
    GroupBox1: TGroupBox;
    Imagem2: TImage;
    OpenDialogImage: TOpenDialog;
    Histograma1: TImage;
    Histograma2: TImage;
    procedure BtEqualizarHistogramaClick(Sender: TObject);
    procedure BtAbrirImagemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHistograma: TFormHistograma;
  ImagemPGM1: ImagemPGM;
  HistogramaDados1: TIntegerDynArray;
  HistogramaDados2: TIntegerDynArray;

implementation

{$R *.dfm}

procedure TFormHistograma.BtAbrirImagemClick(Sender: TObject);
begin
  if OpenDialogImage.Execute
  then
  begin
    ImagemPGM1 := AbrirImagem(OpenDialogImage.FileName);
    LimparImagem(Imagem1);
    DesenharImagem(ImagemPGM1, Imagem1);

    // Desenhando o Histograma
    HistogramaDados1 := GerarHistograma(ImagemPGM1);
    DesenharHistograma(Histograma1, HistogramaDados1);
  end;
end;

procedure TFormHistograma.BtEqualizarHistogramaClick(Sender: TObject);
var
  ImagemPGM2: ImagemPGM;
begin
  // Aplicando a Equalização de Histograma
  ImagemPGM2 := AplicarEqHistograma(ImagemPGM1);

  // Desenhando a imagem equalizada
  DesenharImagem(ImagemPGM2, Imagem2);

  // Desenhando o Histograma
  HistogramaDados2 := GerarHistograma(ImagemPGM2);
  DesenharHistograma(Histograma2, HistogramaDados2);
end;

end.

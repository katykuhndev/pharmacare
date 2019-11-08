class RecomendacionMailer < ApplicationMailer
  default from: 'notifications@example.com'
 
  def informe_recomendacion
    @recomendacion = params[:recomendacion]
    @qf_soporte = @recomendacion.qf_soporte
    asunto = @recomendacion.get_nombre_carta_recomendacion
    attachments.inline['logo_pharma_carta.png'] = File.read('app/assets/images/logo_pharma_carta.png')
    attachments["#{asunto}.pdf"] = @recomendacion.carta_pdf.blob.download
    mail(to: 'katykuhn@gmail.com', subject: asunto)
  end
end

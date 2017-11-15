class FilesController < ApplicationController
  require 'doc_2_pdf'

  def create
    # create pdf with md5sum and uploaded file
    file, md5 = Doc2Pdf.save_uploaded(params[:file])
    dest = Doc2Pdf.convert(file, md5)
    send_file(dest)
  end

  def show
    # get pdf file with md5sum
    begin
      file = Doc2Pdf.get_file(params[:md5])
    rescue IOError
      render json: {err: "File Not Found", status: 404}
    else
      send_file(file)
    end

  end

end

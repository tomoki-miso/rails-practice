class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: "作成完了" }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def uploaded_pdf
    uploaded_pdf = params[:pdf]
    if uploaded_pdf.blank?
      flash.now[:alert] = "PDFを選択してください"
      render :new, status: :unprocessable_entity
      return
    end

    unless uploaded_pdf.content_type == "application/pdf"
      flash.now[:alert] = "PDFファイルを選択してください"
      render :new, status: :unprocessable_entity
      return
    end

    file_id = SecureRandom.uuid
    pdf_dir = Rails.root.join("public", "uploads", "pdfs")
    FileUtils.mkdir_p(pdf_dir)
    pdf_path = pdf_dir.join("#{file_id}.pdf")

    File.open(pdf_path, "wb") do |file|
      file.write(uploaded_pdf.read)
    end

    @pdf_url = "/uploads/pdfs/#{file_id}.pdf"

    render :new, status: :ok
  end

  def group_params
    params.expect(group: %i[title description pdf])
  end
end

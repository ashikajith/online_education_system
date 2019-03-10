class Portal::LibraryController < ApplicationController
  layout 'resource'
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @subjects = load_my_subjects  
  end

  def new
    load_data
  end

  def create
    @library = Library.new(library_params)
    if @library.save
      flash[:success] = "Uploaded Successfully"
      redirect_to portal_library_index_path
    else  
      flash[:error] = display_errors(@library)
      load_data
      render 'new'
    end  
  end

  def edit
   load_data
  end

  def subject_library
    @sub = Subject.find(params[:subject_id])
    @libraries = @sub.libraries
    if request.xhr?
      if params[:year] && params[:subject_id]
        get_library params[:subject_id], params[:year]
        respond_to do |format|
          format.js
        end
      end    
    end    
  end

  def update
    if @library.update(library_params)
      flash[:notice] = "Successfully Updated"
      redirect_to portal_library_index_path
    else
      flash[:error] = display_errors(@library)
      load_data
      render 'edit'
    end  
  end

  def destroy
    if @library.destroy
      flash[:notice] = "Deleted Successfully"
    else
      flash[:error] = display_errors(@library)
    end
    redirect_to portal_library_index_path    
  end

   private 

  class LibraryParams
    def self.build params
      params.require(:library).permit(:subject_id, :year, :unit_id, :synopsis_name, :ebook_name, :synopsis_file, :ebook_file, :synopsis_image, :ebook_image)
    end
  end  
  
  def library_params
    LibraryParams.build(params)
  end

  def load_data
    @subjects = load_my_subjects
    @units = load_my_units
  end

  def get_library subject, year
    query = {}
    query[:year] = year unless year.empty?
    query[:subject_id] = subject unless subject.empty?
    @libraries = Library.all.where(query)
  end
end


class Admin::CountriesController < Admin::ApplicationController
  before_filter :find_country, :only => [:edit, :update, :destroy, :delete]

  def index
    @countries = Country.all.page(params[:page]).per(20)
    @no = paging(20)
  end

  def new
    @country = Country.new
  end

  def create
    puts params.inspect
    @country = Country.new(country_params)
    if @country.save
      flash[:notice] = 'Country was successfully create.'
      redirect_to admin_countries_path
    else
      flash[:error] = "Country failed to create"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @country.update_attributes(country_params)
      flash[:notice] = 'Country was successfully updated.'
      redirect_to admin_countries_path
    else
      flash[:error] = "Country failed to update"
      render :action => :edit
    end
  end

  def destroy
    flash[:notice] =  @country.destroy ? 'Country was successfully deleted.' :
                                           'Country was falied to delete.'
    redirect_to admin_countries_path
  end

  private

    def country_params
      params.require(:country).permit(:name, :category_type, :permalink)
    end

    def find_country
      @country = Country.find_by_id(params[:id])
      if @country.nil?
        flash[:notice] = "Cannot find the Country with id '#{params[:id]}'"
        redirect_to admin_countries_path
     end
    end
end
class MeasureController < ApplicationController


  # List all measures created by a user...
  def list
    begin
     user=User.find_by_apiKey(params[:key])
     if user     
      @measures=Measure.find_all_by_userid(user.id)
     else
        @error="API Key not know....";
     end
    rescue =>e
       @error=e
    end
    render :layout=>false
  end
  
  # delete a meseaure created by a user...
  def delete
  
    logger.info "Will delete a Measure..."
    begin
      if params[:user]==nil
        user=User.find_by_apiKey(params[:key])
        params[:user]=user.login
      end      
      
      measure=Measure.find(params[:id])
      if(measure.userid==user.id)
         measure.delete
      else
         @error="Error, this measure does not belongs to you"
      end
    rescue =>e
       @error=e
    end
    render :layout=>false
  end
  
  def add
    logger.info "Will add Measure..."
    begin
      if params[:user]==nil
        user=User.find_by_apiKey(params[:key])
        params[:user]=user.login
      end

      if((params[:lat].to_f==0)||(params[:lon].to_f==0))
         puts "la.."
         @error="one of the two coordinate is null, which means probably an error..."
      else
         @measure=Measure.createMeasure(params) 
      end
      
    rescue =>e
       logger.error e
       @error=e
          
    end
      
      render :layout=>false
  end
  
  
   def map
    @map=true
    @measures=Measure.find_all_by_cell_id(params[:id])
    @cell=Cell.find(params[:id])
    if !@measures then @measures=[] end
   end
end
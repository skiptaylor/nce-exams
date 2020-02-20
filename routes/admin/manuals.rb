get '/admin/manuals/?' do
	admin!
	@manual = Manual.all
  
	erb :'admin/manuals'
end

get '/admin/manuals/new/?' do
	admin!
	@manual = Manual.new
  
	erb :'admin/manual_edit'
end

post '/admin/manuals/new/?' do
	admin!
	manual = Manual.create(
		name: params[:name],
    title_page: params[:title_page],
		version: params[:version],
    isbn: params[:isbn]
	)
  
	redirect "/admin/manuals"
end

get '/admin/manuals/:id/edit/?' do
  admin!
  @manual = Manual.get(params[:id])
  
  erb :'admin/manual_edit'
end

post '/admin/manuals/:id/edit/?' do
  admin!
  manual = Manual.get(params[:id])
	manual.update(
	  name: params[:name],
    title_page: params[:title_page],
	  version: params[:version],
    isbn: params[:isbn]
	)
  
  redirect "/admin/manuals/"
end

get '/admin/manuals/:id/delete/?' do
	admin!
	manual = Manual.get(params[:id])
  manual.destroy
	
	redirect "/admin/manuals/"
end





get '/admin/manuals/:manual_id/sections/?' do
	admin!
  @manual = Manual.get(params[:manual_id])
	@section = @manual.sections
  
	erb :'admin/sections'
end

get '/admin/manuals/:manual_id/sections/new/?' do
	admin!
  @manual = Manual.get(params[:manual_id])
	@section = @manual.sections.new
  
	erb :'admin/section_edit'
end

post '/admin/manuals/:manual_id/sections/new/?' do
	admin!
	section = Section.create(
    manual_id:      params[:manual_id],
		section_number: params[:section_number],
    section_title:  params[:section_title]
	)
  
	redirect "/admin/manuals/#{params[:manual_id]}/sections"
end

get '/admin/manuals/:manual_id/sections/:id/edit/?' do
  admin!
  @manual = Manual.get(params[:manual_id])
  @section = Section.get(params[:id])
  
  erb :'admin/section_edit'
end

post '/admin/manuals/:manual_id/sections/:id/edit/?' do
  admin!
  manual = Manual.get(params[:manual_id])
  section = Section.get(params[:id])
	section.update(
	  section_number: params[:section_number],
    section_title: params[:section_title]
	)
  
  redirect "/admin/manuals/#{params[:manual_id]}/sections"
end

get '/admin/manuals/:manual_id/sections/:id/delete/?' do
	admin!
  manual = Manual.get(params[:manual_id])
  section = Section.get(params[:id])
	section.destroy
	
	redirect "/admin/manuals/#{params[:manual_id]}/sections"
end





get '/admin/manuals/:manual_id/sections/:section_id/chapters/?' do
	admin!
  @manual = Manual.get(params[:manual_id])
  @section = Section.get(params[:section_id])
	@chapter = @section.chapters
  
	erb :'admin/chapters'
end

get '/admin/manuals/:manual_id/sections/:section_id/chapters/new/?' do
	admin!
  @manual = Manual.get(params[:manual_id])
	@section = Section.get(params[:section_id])
	@chapter = Chapter.new
  
	erb :'admin/chapter_edit'
end

post '/admin/manuals/:manual_id/sections/:section_id/chapters/new/?' do
	admin!
	chapter = Chapter.create(
    section_id: params[:section_id],
		chapter_number: params[:chapter_number],
    chapter_title: params[:chapter_title],
    sub_chapter_title: params[:sub_chapter_title],
    body: params[:body]
	)
  
	redirect "/admin/manuals/#{params[:manual_id]}/sections/#{params[:section_id]}/chapters"
end

get '/admin/manuals/:manual_id/sections/:section_id/chapters/:id/edit/?' do
  admin!
  @manual = Manual.get(params[:manual_id])
	@section = Section.get(params[:section_id])
  @chapter = Chapter.get(params[:id])
  
  erb :'admin/chapter_edit'
end

post '/admin/manuals/:manual_id/sections/:section_id/chapters/:id/edit/?' do
  admin!
  chapter = Chapter.get(params[:id])
	chapter.update(
	  chapter_number: params[:chapter_number],
    chapter_title: params[:chapter_title],
    sub_chapter_title: params[:sub_chapter_title],
    body: params[:body]
	)
  
  redirect "/admin/manuals/#{params[:manual_id]}/sections/#{params[:section_id]}/chapters/#{params[:id]}/view"
end

get '/admin/manuals/:manual_id/sections/:section_id/chapters/:id/view/?' do
  admin!
  @manual = Manual.get(params[:manual_id])
	@section = Section.get(params[:section_id])
  @chapter = Chapter.get(params[:id])
  
  erb :'admin/chapter_view'
end

get '/admin/manuals/:manual_id/sections/:section_id/chapters/:id/delete/?' do
	admin!
  manual = Manual.get(params[:manual_id])
	section = Section.get(params[:section_id])
  chapter = Chapter.get(params[:id])
  chapter.destroy
	
	redirect "/admin/manuals/#{params[:manual_id]}/sections/#{params[:section_id]}/chapters"
end


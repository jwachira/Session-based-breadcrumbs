module SessionBasedBreadCrumbs
  def breadcrumbs(sep = "»", include_home = false, current_location)
    # we want to make sure that we maintain the original path, incase the path changes, destroy the session
    #and begin a new path
    unless session[:current_location] == current_location
      session[:current_location] = current_location
      session[:breadcrumbs]  = nil
    end

    session[:breadcrumbs] ||= []

    title    = request.path.split('?')[0].split('/').last.titleize.gsub(/_/, ' ')
    url      = request.path

    path     = "#{title}:#{url}"

    if session[:breadcrumbs].include?(path)
      session[:breadcrumbs].delete_if{|p| session[:breadcrumbs].index(p) >= session[:breadcrumbs].index(path)}
      session[:breadcrumbs] << path
    else
     session[:breadcrumbs] << path
    end

    links = ""

    links += content_tag('a', "home", :href => "/") if include_home

    session[:breadcrumbs].each do |path|

      path = path.split(':')

      links += " #{sep} #{content_tag('a', path[0], :href => path[1])}"
    end 

    content_tag("div", content_tag("p", links ), :id => "breadcrumb")
  end
end
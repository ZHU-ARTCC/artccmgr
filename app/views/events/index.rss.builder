#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{Artccmgr::Application::ORG_NAME} Events"
    xml.author Artccmgr::Application::ORG_NAME
    xml.description "Events Calendar"
    xml.lastBuildDate Time.now
    xml.link root_url
    xml.language "en"

    for event in @events
      xml.item do
        xml.title event.name
        xml.author "ARTCC Manager Events"
        xml.pubDate event.start_time.to_s(:rfc822)
        xml.link event_url(event)
        xml.guid event.id
        xml.description event.description

      end
    end
  end
end
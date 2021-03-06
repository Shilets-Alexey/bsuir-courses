require 'mechanize'
class ReviewsParse
  def initialize(names)
    @names = names
  end

  def reviews_parse
    agent = Mechanize.new
    page = agent.get('http://bsuir-helper.ru/lectors')
    reviews = {}
    @names.each do |name|
      surname, fstname, dadname = name.split
      link = page.link_with(:text =>
        %r{#{surname}\s+#{fstname[0]}[а-я]+\s+#{dadname[0]}[а-я]+})
      comments = comments_search(link)
      reviews[name] = comments
    end
    reviews
  end

  private

  def comments_search(link)
    comments = {}
    unless link.nil?
      comments_link = link.click
      comments_link.search('.comment').each do |n|
        date = n.search('.comment-date').text
        comment = n.search('.content').text
        comments[date] = comment
      end
    end
    comments
  end
end

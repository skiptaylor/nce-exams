# Clear out all the current data
DataMapper.repository(:default).adapter.execute("delete from taxes")

CSV.open('./data/taxes-2015.csv', { headers: true }) do |csv_lines|
  csv_lines.each do |line|
    Tax.create(
      zip:     line['ZipCode'],
      rate:    line['CombinedRate']
    )
  end
end

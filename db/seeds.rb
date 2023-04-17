# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ChallengeTask.create(
  [
    {content:"普段言わない人に感謝の気持ちを伝えよう！家族、友人、同僚誰でも構いません"},
    {content:"コミュニティ内で話さない人に話かけてみよう！"},
    {content:"店員さんと世間話をしてみよう！"},
    {content:"困っている人を積極的に助けてみよう！"}
  ]
)
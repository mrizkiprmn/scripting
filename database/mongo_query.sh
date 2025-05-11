# select all process with id
db.getCollection('collection_name').find({
  id: 1,
});

# update
db.collection_name.updateOne(
  { id: 1 },
  {
    $set: {
      "processes.$[elem].start_date": ISODate("2025-04-25T00:00:00Z"),
      "processes.$[elem].end_date": ISODate("2025-04-26T00:00:00Z"),
      "processes.$[elem].updated_at": new Date()
    }
  },
  {
    arrayFilters: [{ "elem.process": "process" }]
  }
)
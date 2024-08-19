using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;

namespace Velzon;

public static class EnumerableExtensions
{
  public static DataTable ToDataTable<T>(this IEnumerable<T> data)
  {
    var dataTable = new DataTable(typeof(T).Name);

    // Get all the properties
    var props = TypeDescriptor.GetProperties(typeof(T));

    // Setting column names as Property names
    foreach (PropertyDescriptor prop in props)
    {
      dataTable.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
    }

    // Adding rows
    foreach (T item in data)
    {
      var values = new object?[props.Count];
      for (int i = 0; i < props.Count; i++)
      {
        values[i] = props[i].GetValue(item);
      }
      dataTable.Rows.Add(values);
    }

    return dataTable;
  }
}
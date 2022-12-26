# -*- coding: utf-8 -*-
"""
Created on n Nov 21 18:51:35 2022

Students names:
    1- Ali Al-Badi
    2- Almoatamid Al-Subi
    3- Abdulrhaman Al-Hinai

Purpose:
    To Build AI Recommendation System using Collabrative Filtering Algorithm
    
"""
import numpy as np
import pandas as pd
import warnings


from flask import Flask
from flask import request
from flask import jsonify


#import csv

app = Flask(__name__)

@app.route('/',methods=['GET'])

def recommender():
    warnings.simplefilter(action='ignore', category=FutureWarning)
      
    ratings = pd.read_csv("ratings.csv")
    ratings.head()
    #print(ratings)
    events = pd.read_csv("events.csv")
    events.head()
      
    #n_ratings = len(ratings)
    #n_events = len(ratings['eventId'].unique())
    #n_users = len(ratings['userId'].unique())
      
    #print(f"Number of ratings: {n_ratings}")
    #print(f"Number of unique eventId's: {n_events}")
    #print(f"Number of unique users: {n_users}")
    #print(f"Average ratings per user: {round(n_ratings/n_users, 2)}")
    #print(f"Average ratings per event: {round(n_ratings/n_events, 2)}")
      
    user_freq = ratings[['userId', 'eventId']].groupby('userId').count().reset_index()
    
    user_freq.columns = ['userId', 'n_ratings']
    user_freq.head()
      
      
    # Find Lowest and Highest rated events:
    mean_rating = ratings.groupby('eventId')[['rating']].mean()
    # Lowest rated events
    lowest_rated = mean_rating['rating'].idxmin()
    events.loc[events['eventId'] == lowest_rated]
    # Highest rated events
    highest_rated = mean_rating['rating'].idxmax()
    events.loc[events['eventId'] == highest_rated]
    # show number of people who rated events rated event highest
    ratings[ratings['eventId']==highest_rated]
    # show number of people who rated events rated event lowest
    ratings[ratings['eventId']==lowest_rated]
      
    ## the above events has very low dataset. We will use bayesian average
    event_stats = ratings.groupby('eventId')[['rating']].agg(['count', 'mean'])
    event_stats.columns = event_stats.columns.droplevel()
      
    # Now, we create user-item matrix using scipy csr matrix
    from scipy.sparse import csr_matrix
      
    def create_matrix(df):
          
        N = len(df['userId'].unique())
        M = len(df['eventId'].unique())
          
        # Map Ids to indices
        user_mapper = dict(zip(np.unique(df["userId"]), list(range(N))))
        event_mapper = dict(zip(np.unique(df["eventId"]), list(range(M))))
          
        # Map indices to IDs
        user_inv_mapper = dict(zip(list(range(N)), np.unique(df["userId"])))
        event_inv_mapper = dict(zip(list(range(M)), np.unique(df["eventId"])))
          
        user_index = [user_mapper[i] for i in df['userId']]
        event_index = [event_mapper[i] for i in df['eventId']]
      
        X = csr_matrix((df["rating"], (event_index, user_index)), shape=(M, N))
          
        return X, user_mapper, event_mapper, user_inv_mapper, event_inv_mapper
      
    X, user_mapper, event_mapper, user_inv_mapper, event_inv_mapper = create_matrix(ratings)
    
    from sklearn.neighbors import NearestNeighbors
    """,
    """
    def find_similar_events(event_id, X, k, metric='cosine', show_distance=False):
          
        neighbour_ids = []
          
        event_ind = event_mapper[event_id]
        event_vec = X[event_ind]
        k+=1
        kNN = NearestNeighbors(n_neighbors=k, algorithm="brute", metric=metric)
        kNN.fit(X)
        event_vec = event_vec.reshape(1,-1)
        neighbour = kNN.kneighbors(event_vec, return_distance=show_distance)
        for i in range(0,k):
            n = neighbour.item(i)
            neighbour_ids.append(event_inv_mapper[n])
        neighbour_ids.pop(0)
        return neighbour_ids
      
      
    event_titles = dict(zip(events['eventId'], events['title']))
    
    event_id = int(request.args['Query'])
    
    #print("*"*50)
    
      
    similar_ids = find_similar_events(event_id, X, k=10)
    #event_title = event_titles[event_id]
    
    
    #print(f"Since you watched {event_title}")
    #print("*"*50)
    d = {}
    for i in similar_ids:
        #print(event_titles[i])
        d[str(i)] = str(event_titles[i])
    
    
    return jsonify(d)

if __name__ == '__main__':
    app.run()